//
//  AlcoholEntry.swift
//  SipWise
//
//  Created by MAC on 2026/4/22.
//

import Foundation

struct AlcoholEntry: Identifiable {
    let id = UUID()
    let level: Double
    let date: Date
    var addedByUser: Bool = true
}

enum Drinks: CaseIterable {
    case beer, shot
       
    var asset: String {
       switch self {
       case .beer:
           return "beer"
       case .shot:
           return "shot"
       }
    }
    
    var defaultPercentage: Double {
        switch self {
        case .beer:
            return 4.0
        case .shot:
            return 15.0
        }
    }

    func gramsOfAlcohol(ml: Double, percentage: Double) -> Double {
       let pureAlcoholMl = ml * (percentage / 100)
       return pureAlcoholMl * 0.789
    }
}
