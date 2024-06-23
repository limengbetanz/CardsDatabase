//
//  CardBookmarksViewModel.swift
//  CardsDatabase
//
//  Created by Meng Li on 20/06/2024.
//

import Foundation
import Combine

class CardBookmarksViewModel: ObservableObject {
    static private var filterTypeAll = "All"
    
    @Published private(set) var bookmarksForDisplay: [CardViewModel] = []
    
    @Published var currentFilter: String = CardBookmarksViewModel.filterTypeAll
    @Published private(set) var isFilterShown = false
    var filterTypes: [String] {
        let typeArray = allBookmarks.map { $0.type }
        let typeSet: Set<String> = Set(typeArray)
        var sortedTypeArray = typeSet.sorted()
        sortedTypeArray.insert(CardBookmarksViewModel.filterTypeAll, at: 0)
        
        return sortedTypeArray
    }
    
    @Published private var allBookmarks: [CardViewModel] = []
    private var cancellables = Set<AnyCancellable>()
    private let cardsPersistenceManager: any CardsPersistenceManagerProtocol
    
    init(cardsPersistenceManager: any CardsPersistenceManagerProtocol) {
        
        self.cardsPersistenceManager = cardsPersistenceManager
        
        cardsPersistenceManager.persistedCardsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] bookmarks in
                guard let self = self else { return }
                
                let cardViewModels = bookmarks.map({ card in
                    let cardViewModel = CardViewModel(card: card)
                    cardViewModel.bookmarked = true
                    return cardViewModel
                })
                
                self.allBookmarks = cardViewModels
            }
            .store(in: &cancellables)
        
        $allBookmarks
            .sink { [weak self] allBookmarks in
                guard let self = self else { return }
                // Refresh card list if the count of allBookmarks was changed
                self.filterBookmarks(from: allBookmarks, by: self.currentFilter)
                self.isFilterShown = allBookmarks.isEmpty == false
            }
            .store(in: &cancellables)
        
        $currentFilter
            .sink { [weak self] currentFilter in
                guard let self = self else { return }
                self.filterBookmarks(from: self.allBookmarks, by: currentFilter)
            }
            .store(in: &cancellables)
    }
    
    func fetchBookmarks() {
        cardsPersistenceManager.fetchAllCards(onCompletion: {})
    }
    
    func removeBookmark(_ card: CardViewModel) {
        cardsPersistenceManager.deleteCard(card.card)
        card.bookmarked = false
    }
    
    func resetStates() {
        currentFilter = CardBookmarksViewModel.filterTypeAll
    }
    
    // MARK: - Private functions
    
    private func filterBookmarks(from bookmarks: [CardViewModel], by type: String) {
        if type == CardBookmarksViewModel.filterTypeAll {
            bookmarksForDisplay = bookmarks
        } else {
            let filteredCards = bookmarks.filter({ $0.type == type })
            if filteredCards.isEmpty {
                bookmarksForDisplay = bookmarks
            } else {
                bookmarksForDisplay = filteredCards
            }
        }
    }
}
