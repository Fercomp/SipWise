//
//  HistoryModel.swift
//  SipWise
//
//  Created by MAC on 2026/5/1.
//

import Foundation
import SwiftData
import SwiftUI

enum ConsumptionLevel: Codable {
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

@Model
class HistoryModel {
    var totalGramsOfAlcohol: Double
    var day: Date
    
    init(totalGramsOfAlcohol: Double, day: Date) {
        self.totalGramsOfAlcohol = totalGramsOfAlcohol
        self.day = day
    }
    
    var consumption: ConsumptionLevel {
        switch totalGramsOfAlcohol {
        case 1...12:
            return .low
        case 13...36:
            return .moderate
        default:
            return .high
        }
    }
}
