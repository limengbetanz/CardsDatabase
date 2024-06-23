//
//  AlertInfo.swift
//  CardsDatabase
//
//  Created by Meng Li on 20/06/2024.
//

import Foundation

enum AlertType: String, CaseIterable {
    case apiError
    case coreDataError
}

struct AlertInfo: Identifiable, Equatable {
    let type: AlertType
    let title: String
    let message: String?
    let action: (() -> Void)?
    
    var id: String {
        return type.rawValue
    }
    
    init(type: AlertType, title: String, message: String?, action: (() -> Void)? = nil) {
        self.type = type
        self.title = title
        self.message = message
        self.action = action
    }
    
    public static func == (lhs: AlertInfo, rhs: AlertInfo) -> Bool {
        return lhs.type == rhs.type
    }
}
