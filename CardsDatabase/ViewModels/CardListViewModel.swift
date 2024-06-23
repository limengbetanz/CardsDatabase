//
//  CardListViewModel.swift
//  CardsDatabase
//
//  Created by Meng Li on 20/06/2024.
//

import Foundation
import Combine
import SwiftUI

class CardListViewModel: ObservableObject {
    static private var filterTypeAll = "All"

    @Published private(set) var allCards: [CardViewModel] = []
    @Published private(set) var cardsForDisplay: [CardViewModel] = []
    
    @Published var currentFilter: String = CardListViewModel.filterTypeAll
    @Published private(set) var isFilterShown = false
    var filterTypes: [String] {
        let typeArray = allCards.map { $0.type }
        let typeSet: Set<String> = Set(typeArray)
        var sortedTypeArray = typeSet.sorted()
        sortedTypeArray.insert(CardListViewModel.filterTypeAll, at: 0)
        
        return sortedTypeArray
    }
    
    @Published private(set) var isLoading = false
    @Published var alertInfo: AlertInfo?
    
    @Published private var bookmarkedCardIds: [Int] = []
    
    private var cancellables = Set<AnyCancellable>()
    private var currentPage = 0
    private let pageSize = 100
    private var canLoadMorePages = true
    
    private let cardsApiSevice: CardsApiSeviceProtocol
    private let cardsPersistenceManager: any CardsPersistenceManagerProtocol
    
    init(cardsApiSevice: CardsApiSeviceProtocol,
         cardsPersistenceManager: any CardsPersistenceManagerProtocol) {
        
        self.cardsApiSevice = cardsApiSevice
        self.cardsPersistenceManager = cardsPersistenceManager
        
        cardsPersistenceManager.persistedCardsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] bookmarks in
                guard let self = self else { return }
                self.bookmarkedCardIds = bookmarks.map({ $0.id })
            }
            .store(in: &cancellables)
        
        cardsPersistenceManager.deletedCardPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] deletedCard in
                // If a bookmark is removed from Bookmarks view, the bookmark of the card in Card list view
                // needs to be updated as well.
                guard let self = self else { return }
                guard let card = self.allCards.first(where: { $0.id == deletedCard?.id }) else { return }
                card.bookmarked = false
            }
            .store(in: &cancellables)
        
        $allCards
            .sink { [weak self] allCards in
                guard let self = self else { return }
                self.filterCards(from: allCards, by: self.currentFilter)
                self.isFilterShown = allCards.isEmpty == false
            }
            .store(in: &cancellables)
        
        $currentFilter
            .sink { [weak self] currentFilter in
                guard let self = self else { return }
                self.filterCards(from: self.allCards, by: currentFilter)
            }
            .store(in: &cancellables)
        
        // Need to sync the cached bookmarks to the cards fetched from the server.
        cardsPersistenceManager.fetchAllCards(onCompletion: { [weak self] in
            self?.fetchCards()
        })
    }
    
    func fetchCards() {
        // Only fetch new cards if the current credit card list is showing all cards and canLoadMorePages is true
        guard canLoadMorePages,
              currentFilter == CardListViewModel.filterTypeAll,
              isLoading == false else {
            return
        }
        
        isLoading = true
        
        cardsApiSevice.fetchCards(pageNumber: currentPage, pageSize: pageSize)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else {
                    return
                }

                self.isLoading = false

                switch completion {
                case .failure(let error):
                    self.alertInfo = AlertInfo(type: .apiError, title: "Error", message: error.localizedDescription)
                    break
                case .finished:
                    break
                }

            }, receiveValue: { [weak self] cards in
                guard let self = self else {
                    return
                }
                
                let cardViewModels = cards.map({ CardViewModel(card: $0) })
                self.allCards.append(contentsOf: cardViewModels)
                
                self.currentPage += 1
                self.canLoadMorePages = cards.count == self.pageSize
                
                self.synchronizeBookmarks(newCards: cardViewModels)
            })
            .store(in: &cancellables)
    }
    
    func toggleBookmark(_ card: CardViewModel) {
        if card.bookmarked {
            card.bookmarked = false
            cardsPersistenceManager.deleteCard(card.card)
        } else {
            card.bookmarked = true
            cardsPersistenceManager.addCard(card.card)
        }
    }
    
    // MARK: - Private functions
    
    private func filterCards(from cards: [CardViewModel], by type: String) {
        if type == CardListViewModel.filterTypeAll {
            cardsForDisplay = cards
        } else {
            cardsForDisplay = cards.filter({ $0.type == type })
        }
    }
    
    private func synchronizeBookmarks(newCards: [CardViewModel]) {
        newCards.forEach({ card in
            if bookmarkedCardIds.contains(card.id) {
                card.bookmarked = true
            }
        })
    }
}
