//
//  HistoryView.swift
//  SipWise
//
//  Created by Fernando Santos de Souza on 23/04/26.
//

import SwiftUI

let mockHistory: [HistoryModel] = [
    HistoryModel(totalGramsOfAlcohol: 6, day: Date().addingTimeInterval(-86400 * 6)),
    HistoryModel(totalGramsOfAlcohol: 12, day: Date().addingTimeInterval(-86400 * 5)),
    HistoryModel(totalGramsOfAlcohol: 24, day: Date().addingTimeInterval(-86400 * 4)),
    HistoryModel(totalGramsOfAlcohol: 8, day: Date().addingTimeInterval(-86400 * 3)),
    HistoryModel(totalGramsOfAlcohol: 36, day: Date().addingTimeInterval(-86400 * 2)),
    HistoryModel(totalGramsOfAlcohol: 18, day: Date().addingTimeInterval(-86400 * 1)),
    HistoryModel(totalGramsOfAlcohol: 20, day: Date())
]

import SwiftUI

enum ConsumptionLevel {
    case low
    case moderate
    case high
    
    var label: String {
        switch self {
        case .low:
            return "Consumo leve"
        case .moderate:
            return "Consumo moderado"
        case .high:
            return "Consumo alto"
        }
    }
    
    var color: Color {
        switch self {
        case .low:
            return .green
        case .moderate:
            return .orange
        case .high:
            return .red
        }
    }
}

struct HistoryView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(mockHistory.indices, id: \.self) { index in
                    HistoryCardView(model: mockHistory[index])
                }
            }
            .padding()
        }
    }
}

#Preview {
    HistoryView()
}
