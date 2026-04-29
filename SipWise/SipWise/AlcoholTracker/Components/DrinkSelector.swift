//
//  DrinkSelector.swift
//  Beer
//
//  Created by Fernando Santos de Souza on 08/04/26.
//

import SwiftUI

struct DrinkSelector: View {
    @State private var alcohol: Double = 5.0
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
                .tint(.blue)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(4)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color(UIColor.systemGray4), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: 4)
            
            Spacer()
            
            Text(String(format: "%.1f %%", alcohol))
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(.cyan)
            
            Stepper("", value: $alcohol, in: 0...100, step: 1)
                .labelsHidden()
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(UIColor.secondarySystemGroupedBackground))
                .shadow(color: .black.opacity(0.08), radius: 5, x: 0, y: 4)
        )
    }
}

#Preview {
    DrinkSelector(selectedDrink: .constant(.beer))
}
