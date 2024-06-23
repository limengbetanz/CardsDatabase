//
//  CardsPersistenceManager.swift
//  CardsDatabase
//
//  Created by Meng Li on 20/06/2024.
//

import Foundation
import CoreData
import Combine

protocol CardsPersistenceManagerProtocol: ObservableObject {
    var persistedCardsPublisher: AnyPublisher<[Card], Never> { get }
    var deletedCardPublisher: AnyPublisher<Card?, Never> { get }
    
    func fetchAllCards(onCompletion: @escaping () -> Void)
    func addCard(_ card: Card)
    func addCards(_ cards: [Card])
    func deleteCard(_ card: Card)
}

class CardsPersistenceManager: CardsPersistenceManagerProtocol, ObservableObject {
    @Published var persistedCards: [Card] = []
    @Published var deletedCard: Card?
    
    var persistedCardsPublisher: AnyPublisher<[Card], Never> {
        $persistedCards.eraseToAnyPublisher()
    }
    
    var deletedCardPublisher: AnyPublisher<Card?, Never> {
        $deletedCard.eraseToAnyPublisher()
    }
    
    private let persistenceService: PersistenceServiceProtocol
    
    init(persistenceService: PersistenceServiceProtocol) {
        self.persistenceService = persistenceService
    }
    
    func fetchAllCards(onCompletion: @escaping () -> Void) {
        let request = CoreDataCard.fetchRequest()
        persistenceService.fetchRecords(request: request, onCompletion: { [weak self] coreDataCards in
            guard let self = self else { return }
            let cards = coreDataCards.map({ item in
                return Card(id: Int(item.id), uid: item.uid, number: item.number, expiryDate: item.expiryDate, type: item.type)
            })
            self.persistedCards = cards
            onCompletion()
        })
    }
    
    func addCard(_ card: Card) {
        addCards([card])
    }
    
    func addCards(_ cards: [Card]) {
        var index = 0
        
        persistenceService.createRecords(entityName: "CoreDataCard", managedObjectHandler: { (managedObject: NSManagedObject) -> Bool in
            guard let coreDataCard = managedObject as? CoreDataCard else {
                NSLog("managedObject isn't CoreDataCard")
                return true
            }
            
            guard index < cards.count else {
                return true
            }
            
            coreDataCard.id = Int32(cards[index].id)
            coreDataCard.uid = cards[index].uid
            coreDataCard.number = cards[index].number
            coreDataCard.expiryDate = cards[index].expiryDate
            coreDataCard.type = cards[index].type
            
            index += 1
            
            return false
        })
        
        persistedCards.append(contentsOf: cards)
    }
    
    func deleteCard(_ card: Card) {
        let request = CoreDataCard.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", card.id)
        persistenceService.deleteRecords(request: request)
        
        persistedCards = persistedCards.filter({ $0.id != card.id })
        deletedCard = card
    }
}
