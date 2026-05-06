//
//  SessionSnapShot.swift
//  SipWise
//
//  Created by Fernando Santos de Souza on 06/05/26.
//

import SwiftData
import Foundation

@Model
class SessionSnapshot {
    var dateSaved: Date
    var alcoholEntries: [AlcoholEntry]
    var drinkCounter: [Drinks: Double]
    var totalAmoutIngested: Double
    
    init(dateSaved: Date, alcoholEntries: [AlcoholEntry], drinkCounter: [Drinks : Double], totalAmoutIngested: Double) {
        self.dateSaved = dateSaved
        self.alcoholEntries = alcoholEntries
        self.drinkCounter = drinkCounter
        self.totalAmoutIngested = totalAmoutIngested
    }
}
