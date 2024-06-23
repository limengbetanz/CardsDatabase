//
//  Card.swift
//  CardsDatabase
//
//  Created by Meng Li on 20/06/2024.
//

import Foundation

struct Card: Decodable, Identifiable {
    let id: Int
    let uid: String
    let number: String
    let expiryDate: String
    let type: String

    enum CodingKeys: String, CodingKey {
        case id
        case uid
        case number = "credit_card_number"
        case expiryDate = "credit_card_expiry_date"
        case type = "credit_card_type"
    }
    
    init(id: Int, uid: String, number: String, expiryDate: String, type: String) {
        self.id = id
        self.uid = uid
        self.number = number
        self.expiryDate = expiryDate
        self.type = type
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        uid = try container.decodeIfPresent(String.self, forKey: .uid) ?? ""
        number = try container.decodeIfPresent(String.self, forKey: .number) ?? ""
        expiryDate = try container.decodeIfPresent(String.self, forKey: .expiryDate)  ?? ""
        type = try container.decodeIfPresent(String.self, forKey: .type) ?? "Unknown"
    }
}
