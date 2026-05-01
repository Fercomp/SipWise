//
//  HistoryModel.swift
//  SipWise
//
//  Created by MAC on 2026/5/1.
//

import Foundation

struct HistoryModel {
    let totalGramsOfAlcohol: Double
    let day: Date
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
