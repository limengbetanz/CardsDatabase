//
//  CardListView.swift
//  CardsDatabase
//
//  Created by Meng Li on 20/06/2024.
//

import SwiftUI

struct CardListView: View {
    @StateObject private var viewModel = CardListViewModel(cardsApiSevice: AppDelegate.cardsApiSevice, cardsPersistenceManager: AppDelegate.cardsPersistenceManager)
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.cardsForDisplay) { card in
                        NavigationLink(destination: CardDetailsView(card: card)) {
                            CardView(card: card, onBookmarkToggled: {
                                viewModel.toggleBookmark(card)
                            })
                            .onAppear {
                                if viewModel.allCards.last == card {
                                    viewModel.fetchCards()
                                }
                            }
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .listStyle(.plain)

                if viewModel.isLoading {
                    loadingIndicatorView
                }
            }
            .navigationTitle("Card List")
            .navigationViewStyle(.stack)
            .toolbar(content: {
                if viewModel.isFilterShown {
                    ToolbarItem(placement: .navigationBarTrailing) {
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
                    }
                }
            })
            .alert(item: $viewModel.alertInfo) { alertInfo in
                Alert(title: Text(alertInfo.title), message: Text(alertInfo.message ?? ""))
            }
        }
    }
    
    var loadingIndicatorView: some View {
        Text("Loading more...")
    }
}

#Preview {
    return NavigationView {
        CardListView()
    }
}
