//
//  DrinkCounter.swift
//  SipWise
//
//  Created by MAC on 2026/4/27.
//

import SwiftUI
struct DrinkCounter: View {
    var counter: [Drinks: Double]
    var totalGrams: Double
    
    var body: some View {
        HStack {
            ForEach(Array(counter.keys.sorted { $0.asset > $1.asset}), id: \.self) { key in
                HStack(spacing: 8) {
                    Image(key.asset)
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text("\(Int(counter[key] ?? 0.0)) ml")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            
            Text(String(format: "Total grams: %.1fg%", totalGrams))
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.cyan)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 40)
        .padding(8)
        .shadowSP()
    }
}


#Preview {
    DrinkCounter(counter: [.beer: 200, .shot: 100], totalGrams: 20)
}
