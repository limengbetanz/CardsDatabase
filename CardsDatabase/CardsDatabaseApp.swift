//
//  CardsDatabaseApp.swift
//  CardsDatabase
//
//  Created by Meng Li on 20/06/2024.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    static let apiSevice: ApiSeviceProtocol = ApiSevice()
    static let cardsApiSevice: CardsApiSeviceProtocol = CardsApiSevice(apiSevice: AppDelegate.apiSevice)
    static let persistenceService: PersistenceServiceProtocol = PersistenceService()
    static let cardsPersistenceManager: any CardsPersistenceManagerProtocol = CardsPersistenceManager(persistenceService: AppDelegate.persistenceService)
}

@main
struct CardsDatabaseApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
