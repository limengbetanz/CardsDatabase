//
//  CardBookmarksView.swift
//  CardsDatabase
//
//  Created by Meng Li on 20/06/2024.
//

import SwiftUI

struct CardBookmarksView: View {
    @StateObject private var viewModel = CardBookmarksViewModel(cardsPersistenceManager: AppDelegate.cardsPersistenceManager)
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.bookmarksForDisplay) { card in
                    NavigationLink(destination: CardDetailsView(card: card)) {
                        CardView(card: card, onBookmarkToggled: {
                            viewModel.removeBookmark(card)
                        })
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .listStyle(.plain)
            .navigationTitle("Bookmarks")
            .navigationViewStyle(.stack)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if viewModel.isFilterShown {
                        Menu(content: {
                            ForEach(viewModel.filterTypes, id: \.self) { type in
                                Button(action: {
                                    viewModel.currentFilter = type
                                }, label: {
                                    Text(type)
                                })
                            }

                         }, label: {
                             Text("Filter")
                        })
                    } else {
                        EmptyView()
                    }
                }
            })
        }
        .onAppear {
            viewModel.fetchBookmarks()
        }
        .onDisappear {
            viewModel.resetStates()
        }
    }
}

#Preview {
    return NavigationView {
        CardBookmarksView()
    }
}
