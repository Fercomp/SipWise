//
//  HistoryCardView.swift
//  SipWise
//
//  Created by Fernando Santos de Souza on 23/04/26.
//

import SwiftUI

struct HistoryCardView: View {
    let model: HistoryModel
    
    var body: some View {
        HStack(spacing: .zero) {
            VStack(alignment: .leading, spacing: 4) {
                Text(formattedDate)
                    .font(.headline)
                
                Text(model.consumption.label)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text("\(Int(model.totalGramsOfAlcohol)) g")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(model.consumption.color)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(.background)
                .shadow(radius: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(model.consumption.color.opacity(0.3), lineWidth: 1)
        )
    }
    
    private var formattedDate: String {
        model.day.formatted(date: .abbreviated, time: .omitted)
    }
}

#Preview {
    HistoryCardView(model: .init(totalGramsOfAlcohol: 15, day: .now))
        .padding()
}
