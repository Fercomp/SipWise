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
    
    private var alcoholPercentage: Double {
        switch self {
        case .beer:
            return 0.05
        case .shot:
            return 0.40
        }
    }
       
    var asset: String {
       switch self {
       case .beer:
           return "beer"
       case .shot:
           return "shot"
       }
    }

    func gramsOfAlcohol(ml: Double) -> Double {
       let pureAlcoholMl = ml * alcoholPercentage
       return pureAlcoholMl * 0.789
    }
}
