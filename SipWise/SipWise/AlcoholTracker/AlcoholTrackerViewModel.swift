//
//  AlcoholTrackerViewModel.swift
//  Beer
//
//  Created by Fernando Santos de Souza on 08/04/26.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class AlcoholTrackerViewModel: ObservableObject {
    /// Currently selected drink type
    @Published var selectedDrink: Drinks = .beer
    /// UI color representing current alcohol level/risk
    @Published var chartColor: Color = .green
    /// Logged alcohol entries over time
    @Published var alcoholEntries: [AlcoholEntry] = []
    /// Current drink volume in ml being added
    @Published var currentDrinkValue: Double = 0
    /// Tracker drinks total amount
    @Published var drinkCounter: [Drinks: Double] = [:]
    /// Flag to know if user is currently drinking
    public var isDrinking: Bool  { alcoholEntries.isEmpty }
    /// Reference grams level for moderate/high consumption
    public let threshold = 35
    /// Average alcohol elimination rate (~8 g/hour ≈ 0.0022 g/second)
    private let eliminationPerSecond: Double = 0.0022
    /// Time interval (in seconds) between updates
    private var timeSpace = 1.0
    private var timer: AnyCancellable?
    
    init() {}
    
    private func getGramsOfAlcohol(addedByUser: Bool) -> Double {
        if !addedByUser {
            return 0.0
        }
        return selectedDrink.gramsOfAlcohol(ml: currentDrinkValue)
    }
    
    func addEntry(addedByUser: Bool = true) {
        let gramsOfAlcohol = getGramsOfAlcohol(addedByUser: addedByUser)
        let lastGrams = alcoholEntries.last?.level ?? 0.0
        let newTotalOfAcohol = gramsOfAlcohol + lastGrams - eliminationPerSecond * timeSpace
        guard newTotalOfAcohol > 0 else { return }
        setChartColor(newTotalOfAcohol)
        updateDrinkCounter(currentDrinkValue, drink: selectedDrink, addedByUser: addedByUser)
        alcoholEntries.append(AlcoholEntry(level: gramsOfAlcohol + lastGrams - eliminationPerSecond * timeSpace,
                                 date: Date(),
                                 addedByUser: addedByUser))
        if alcoholEntries.count == 1 {
            startTracking()
        }
    }
    
    private func setChartColor(_ totalOfAlcohol: Double) {
        switch totalOfAlcohol {
        case 0..<20:
            chartColor = .green
        case 20..<40:
            chartColor = .yellow
        case 40..<60:
            chartColor = .orange
        default:
            chartColor = .red
        }
    }
    
    private func updateDrinkCounter(_ totalOfAlcohol: Double, drink: Drinks, addedByUser: Bool) {
        if !addedByUser { return }
        if let currentAmount = drinkCounter[drink] {
            drinkCounter[drink] = currentAmount + totalOfAlcohol
        } else {
            drinkCounter[drink] = totalOfAlcohol
        }
    }
    
    func startTracking() {
        timer?.cancel()
        timer = Timer.publish(every: timeSpace, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.addEntry(addedByUser: false)
                if self.alcoholEntries.count > 150 {
                    self.upShiftGranularity()
                }
            }
    }
    
    private func upShiftGranularity() {
        var newData: [AlcoholEntry] = []
        for (index, entry) in alcoholEntries.enumerated() {
            if index % 3 == 0 || entry.addedByUser {
                newData.append(entry)
            }
        }
        
        self.alcoholEntries = newData
        startTracking()
    }
    
    func stopTracking() {
        timer?.cancel()
        timer = nil
        alcoholEntries = []
        drinkCounter = [:]
    }
}
