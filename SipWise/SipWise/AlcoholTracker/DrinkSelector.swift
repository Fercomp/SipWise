//
//  DrinkSelector.swift
//  Beer
//
//  Created by Fernando Santos de Souza on 08/04/26.
//

import SwiftUI

struct DrinkSelector: View {
    @Binding var selectedDrink: Drinks
    @State private var currentDrink: Int
    @State private var totalVolume: Int
    private var drinks: [Drinks]
    
    public init(selectedDrink: Binding<Drinks>) {
        _selectedDrink = selectedDrink
        currentDrink = 0
        totalVolume = 0
        drinks = Drinks.allCases
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                button(imageName: "chevron.left", action: {
                    currentDrink = (currentDrink - 1 + drinks.count) % drinks.count
                    selectedDrink = drinks[currentDrink]
                })
                Spacer()
                Image(drinks[currentDrink].asset)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                Spacer()
                button(imageName: "chevron.right", action: {
                    currentDrink = (currentDrink + 1) % drinks.count
                    selectedDrink = drinks[currentDrink]
                })
            }
            
            HStack {
                button(imageName: "chevron.left", action: {
                    totalVolume = max(0, totalVolume - 50)
                    
                })
                
                Text("\(totalVolume) ml")
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 99)
                            .stroke(lineWidth: 2)
                    )
                
                button(imageName: "chevron.right", action: {
                    totalVolume += 50
                })
            }
        }
        .fixedSize()
    }
    
    private func button(imageName: String, action: @escaping () -> ()) -> some View {
        Button(action: {
            action()
        }, label: {
            Image(systemName: imageName)
                .foregroundStyle(.black)
        })
    }
}

#Preview {
    DrinkSelector(selectedDrink: .constant(.beer))
}
