//
//  CardDetailsView.swift
//  CardsDatabase
//
//  Created by Meng Li on 20/06/2024.
//

import SwiftUI

struct CardDetailsView: View {
    let card: CardViewModel
    
    var body: some View {
        VStack {
            cardInfoView
            Spacer()
        }
        .navigationTitle("Details")
    }
    
    var cardInfoView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8.0) {
                HStack {
                    Text(card.type)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.primary)
                        .lineLimit(nil)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
                .padding(.vertical)

                HStack {
                    Text("id:")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.secondary)
                    
                    Text(String(card.id))
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(Color.secondary)
                }
                .padding(.bottom)
                
                Text("uid: ")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.secondary)
                
                Text(card.uid)
                    .font(.body)
                    .fontWeight(.regular)
                    .foregroundColor(Color.secondary)
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom)
                
                Text("Number:")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.secondary)
                
                Text(card.number)
                    .font(.body)
                    .fontWeight(.regular)
                    .foregroundColor(Color.secondary)
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom)
                
                Text("Expiry Date:")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.secondary)
                
                Text(card.expiryDate)
                    .font(.body)
                    .fontWeight(.regular)
                    .foregroundColor(Color.secondary)
                    .padding(.bottom)
            }
            .padding()
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.brown, lineWidth: 2)
            )
            .padding()
        }
    }
}

#Preview {
    let card = Card(id: 0, uid: "5351cb41-1a3c-4d8b-a8c4-daf52c264a5d5351cb41-1a3c-4d8b-a8c4-daf52c264a5d", number: "1212-1221-1121-1234-1212-1221-1121-1234-1212-1221-1121-1234", expiryDate: "2030-01-01", type: "VisaVisaVisaVisaVisaVisaVisaVisaVisaVisa")
    let cardViewModel = CardViewModel(card: card)
    
    return NavigationView {
         CardDetailsView(card: cardViewModel)
    }
}
