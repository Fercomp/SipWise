//
//  DrinkSelector.swift
//  Beer
//
//  Created by Fernando Santos de Souza on 08/04/26.
//

import SwiftUI

struct DrinkSelector: View {
    @Binding var alcoholPercentage: Double
    @Binding var selectedDrink: Drinks
    
    var body: some View {
        HStack(spacing: 16) {
            HStack(spacing: 2) {
                Image(selectedDrink.asset)
                    .resizable()
                    .frame(width: 25, height: 25)
                
                Picker("Bebida", selection: $selectedDrink) {
                    ForEach(Drinks.allCases, id: \.self) { drink in
                        Text(drink.asset)
                            .tag(drink)
                    }
                }
                .pickerStyle(.menu)
                .fixedSize()
                .tint(.cyan)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(4)
            .shadowSP()
            
            Spacer()
            
            Text(String(format: "%.1f %%", alcoholPercentage))
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(.cyan)
            
            Stepper("", value: $alcoholPercentage, in: 0...100, step: 1)
                .labelsHidden()
        }
        .padding(24)
        .shadowSP()
        .onChange(of: selectedDrink) {
            alcoholPercentage = selectedDrink.defaultPercentage
        }
    }
}

#Preview {
    DrinkSelector(alcoholPercentage: .constant(5), selectedDrink: .constant(.beer))
}
