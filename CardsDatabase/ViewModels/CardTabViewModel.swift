//
//  CardTabViewModel.swift
//  CardsDatabase
//
//  Created by Meng Li on 20/06/2024.
//

import Foundation
import Combine

enum CardTabViewTab: CaseIterable {
    case list
    case bookmark
}

class CardTabViewModel: ObservableObject {
    @Published var selectedTab: CardTabViewTab = .list
    @Published private(set) var listTabImageName: String = "creditcard"
    @Published private(set) var bookmarkTabImageName: String = "bookmark.square"
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $selectedTab
            .sink { [weak self] selectedTab in
                guard let self = self else { return }
                self.listTabImageName = selectedTab == .list ? "creditcard.fill" : "creditcard"
                self.bookmarkTabImageName = selectedTab == .bookmark ? "bookmark.square.fill" : "bookmark.square"
            }
            .store(in: &cancellables)
    }
}
