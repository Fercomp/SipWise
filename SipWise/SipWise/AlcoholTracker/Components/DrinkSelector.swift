//
//  DrinkSelector.swift
//  Beer
//
//  Created by Fernando Santos de Souza on 08/04/26.
//

import SwiftUI

struct DrinkSelector: View {
    @Binding var selectedDrink: Drinks
    @State private var selectedDrinkIndex: Int
    @Binding private var drinkTotalVolume: Double
    private var drinks: [Drinks]
    
    public init(selectedDrink: Binding<Drinks>,
                drinkTotalVolume: Binding<Double>) {
        _selectedDrink = selectedDrink
        _drinkTotalVolume = drinkTotalVolume
        selectedDrinkIndex = 0
        drinks = Drinks.allCases
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                button(imageName: "chevron.left", action: {
                    selectedDrinkIndex = (selectedDrinkIndex - 1 + drinks.count) % drinks.count
                    selectedDrink = drinks[selectedDrinkIndex]
                })
                Spacer()
                Image(drinks[selectedDrinkIndex].asset)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                Spacer()
                button(imageName: "chevron.right", action: {
                    selectedDrinkIndex = (selectedDrinkIndex + 1) % drinks.count
                    selectedDrink = drinks[selectedDrinkIndex]
                })
            }
            
            HStack {
                button(imageName: "chevron.left", action: {
                    drinkTotalVolume = max(0, drinkTotalVolume - 50)
                })
                
                Text("\(Int(drinkTotalVolume)) ml")
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 99)
                            .stroke(lineWidth: 2)
                    )
                
                button(imageName: "chevron.right", action: {
                    drinkTotalVolume += 50
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
    DrinkSelector(selectedDrink: .constant(.beer),
                  drinkTotalVolume: .constant(100))
}
