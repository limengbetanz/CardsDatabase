//
//  CardTabview.swift
//  CardsDatabase
//
//  Created by Meng Li on 20/06/2024.
//

import SwiftUI

struct CardTabview: View {
    @StateObject private var tabViewModel = CardTabViewModel()
    
    var body: some View {
        TabView(selection: $tabViewModel.selectedTab) {
            CardListView()
                .tabItem {
                    Label("List", systemImage: tabViewModel.listTabImageName)
                }
                .tag(CardTabViewTab.list)
            
            CardBookmarksView()
                .tabItem {
                    Label("Bookmark", systemImage: tabViewModel.bookmarkTabImageName)
                }
                .tag(CardTabViewTab.bookmark)
        }
    }
}

#Preview {
    CardTabview()
}
