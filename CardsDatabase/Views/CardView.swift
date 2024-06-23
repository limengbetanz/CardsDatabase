//
//  CardView.swift
//  CardsDatabase
//
//  Created by Meng Li on 20/06/2024.
//

import SwiftUI

struct CardView: View {
    @ObservedObject var card: CardViewModel
    let onBookmarkToggled: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            HStack {
                Text(card.type)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.primary)
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
                    .accessibilityLabel(card.type)
                
                Spacer()
                
                Button(action: onBookmarkToggled) {
                    Image(systemName: card.bookmarked ? "bookmark.fill" : "bookmark")
                        .foregroundColor(card.bookmarked ? .yellow : .gray)
                        .frame(width: 64, height: 64)
                }
                .accessibilityLabel(card.bookmarked ? "Bookmarked" : "Not Bookmarked")
                .accessibilityHint("Tap to toggle bookmark")

            }

            Text(card.number)
                .font(.body)
                .fontWeight(.regular)
                .foregroundColor(Color.secondary)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
                .accessibilityLabel("Card number: \(card.number)")
            
            Text(card.expiryDate)
                .font(.body)
                .fontWeight(.regular)
                .foregroundColor(Color.secondary)
                .accessibilityLabel("Expiry date: \(card.expiryDate)")
        }
        .padding()
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.brown, lineWidth: 2)
        )
        .padding(.horizontal)
    }
}

#Preview {
    let card = Card(id: 0, uid: "5351cb41-1a3c-4d8b-a8c4-daf52c264a5d5351cb41-1a3c-4d8b-a8c4-daf52c264a5d", number: "1212-1221-1121-1234-1212-1221-1121-1234-1212-1221-1121-1234", expiryDate: "2030-01-01", type: "VisaVisaVisaVisaVisaVisaVisaVisaVisaVisa")
    let cardViewModel = CardViewModel(card: card)
    
    return CardView(card: cardViewModel, onBookmarkToggled: {})
}
