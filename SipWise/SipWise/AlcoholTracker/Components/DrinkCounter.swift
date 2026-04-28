//
//  DrinkCounter.swift
//  SipWise
//
//  Created by MAC on 2026/4/27.
//

import SwiftUI
struct DrinkCounter: View {
    @Binding var counter: [Drinks: Double]
    
    var body: some View {
        HStack {
            ForEach(Array(counter.keys.sorted { $0.asset > $1.asset}), id: \.self) { key in
                HStack(spacing: 8) {
                    Image(key.asset)
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text("\(Int(counter[key] ?? 0.0)) ml")
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 40)
    }
}


#Preview {
    DrinkCounter(counter: .constant([.beer: 200, .shot: 100]))
}
