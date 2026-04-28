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
    private var drinks: [Drinks]
    
    public init(selectedDrink: Binding<Drinks>,
                drinkTotalVolume: Binding<Double>) {
        _selectedDrink = selectedDrink
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
