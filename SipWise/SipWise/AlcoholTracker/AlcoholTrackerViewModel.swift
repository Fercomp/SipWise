//
//  AlcoholTrackerViewModel.swift
//  Beer
//
//  Created by Fernando Santos de Souza on 08/04/26.
//

import Foundation
import Combine
import SwiftUI
import SwiftData

@MainActor
class AlcoholTrackerViewModel: ObservableObject {
    /// Currently selected drink type
    @Published var selectedDrink: Drinks = .beer
    /// UI color representing current alcohol level/risk
    @Published var chartColor: Color = .green
    /// Logged alcohol entries over time
    @Published var alcoholEntries: [AlcoholEntry] = []
    /// Current drink volume in ml being added
    @Published var currentDrinkValue: Double = 300.0
    /// Current drink alcohol percentage
    @Published var currentAlcoholPercentage: Double = 0
    /// Tracker drinks total amount
    @Published var drinkCounter: [Drinks: Double] = [:]
    /// Tracker grams of alcohol ingested
    @Published var totalAmoutIngested: Double = 0.0
    /// Flag to know if user is currently drinking
    public var isDrinking: Bool  { !alcoholEntries.isEmpty }
    /// Reference grams level for moderate/high consumption
    public let threshold = 35
    /// Average alcohol elimination rate (~8 g/hour ≈ 0.0022 g/second)
    private let eliminationPerSecond: Double = 0.022
    /// Time interval (in seconds) between updates
    private var timeSpace = 1.0
    private var timer: AnyCancellable?
    
    private func getGramsOfAlcohol(addedByUser: Bool) -> Double {
        if !addedByUser {
            return 0.0
        }
        return selectedDrink.gramsOfAlcohol(ml: currentDrinkValue, percentage: currentAlcoholPercentage)
    }
    
    func addEntry(addedByUser: Bool = true) {
        let gramsOfAlcohol = getGramsOfAlcohol(addedByUser: addedByUser)
        totalAmoutIngested += gramsOfAlcohol
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
    
    func stopTracking(context: ModelContext) {
        saveData(context: context)
        deleteAllSnapshots(context: context)
        timer?.cancel()
        timer = nil
        alcoholEntries = []
        drinkCounter = [:]
        totalAmoutIngested = 0.0
    }
    
    private func saveData(context: ModelContext) {
        let history = HistoryModel(totalGramsOfAlcohol: totalAmoutIngested, day: Date())
        context.insert(history)
          
        do {
            try context.save()
        } catch {
            print("Failed to save: \(error)")
        }
    }
        
    func saveSnapshot(context: ModelContext) {
        timer?.cancel()
        timer = nil
        deleteAllSnapshots(context: context)
        
        let snapshot = SessionSnapshot(dateSaved: Date(), alcoholEntries: alcoholEntries, drinkCounter: drinkCounter, totalAmoutIngested: totalAmoutIngested)
        context.insert(snapshot)
        
        do {
            try context.save()
        } catch {
            print("Erro ao salvar snapshot: \(error)")
        }
    }
        
    func restoreSnapshot(context: ModelContext) {
        let descriptor = FetchDescriptor<SessionSnapshot>()
        
        guard let snapshots = try? context.fetch(descriptor),
              let snapshot = snapshots.first else {
            if !alcoholEntries.isEmpty && timer == nil { startTracking() }
            return
        }
        
        self.drinkCounter = snapshot.drinkCounter
        self.totalAmoutIngested = snapshot.totalAmoutIngested
        self.alcoholEntries = snapshot.alcoholEntries
        
        let timeElapsedInSeconds = Date().timeIntervalSince(snapshot.dateSaved)
        
        if let lastEntry = alcoholEntries.last {
            let totalEliminated = timeElapsedInSeconds * eliminationPerSecond
            let currentLevel = max(0, lastEntry.level - totalEliminated) // Não deixa ficar < 0
            
            let newEntry = AlcoholEntry(level: currentLevel, date: Date(), addedByUser: false)
            self.alcoholEntries.append(newEntry)
            self.setChartColor(currentLevel)
        }
        
        context.delete(snapshot)
        do {
            try context.save()
        } catch {
            print("Erro ao deletar snapshot: \(error)")
        }
        
        startTracking()
    }
    
    private func deleteAllSnapshots(context: ModelContext) {
        let descriptor = FetchDescriptor<SessionSnapshot>()
        
        do {
            let existingSnapshots = try context.fetch(descriptor)
            for snapshot in existingSnapshots {
                context.delete(snapshot)
            }
            try context.save()
        } catch {
            print("Erro ao deletar os snapshots: \(error)")
        }
    }
}
