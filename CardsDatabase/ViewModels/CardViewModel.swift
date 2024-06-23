//
//  CardViewModel.swift
//  CardsDatabase
//
//  Created by Meng Li on 20/06/2024.
//

import Foundation

class CardViewModel: ObservableObject, Identifiable, Equatable {
    @Published var bookmarked = false
    
    let card: Card
    
    var id: Int {
        return card.id
    }
    
    var uid: String {
        return card.uid
    }
    
    var number: String {
        return card.number.replacingOccurrences(of: "-", with: " ")
    }
    
    var expiryDate: String {
        return card.expiryDate
    }
    
    var type: String {
        return card.type
    }
    
    init(card: Card) {
        self.card = card
    }
    
    public static func == (lhs: CardViewModel, rhs: CardViewModel) -> Bool {
        return lhs.id == rhs.id && lhs.uid == rhs.uid
    }
}
