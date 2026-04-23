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
    @Published var selectedDrink: Drinks = .beer
    @Published var currentDrinkAmount: Int = 0
    @Published var chartColor: Color = .green
    @Published var data: [AlcoholEntry] = []
    private let eliminationPerSecond: Double = 0.15 / 36//00.0
    private var timer: AnyCancellable?
    private var timeSpace = 0.1
    let threshold = 0.8
    
    init() {}
    
    
    func addEntry(_ gramsOfAlcohol: Double, addedByUser: Bool = true) {
        let lastGrams = data.last?.level ?? 0.0
        let newTotalOfAcohol = gramsOfAlcohol + lastGrams - eliminationPerSecond * timeSpace
        guard newTotalOfAcohol > 0 else { return }
        setChartColor(newTotalOfAcohol)
        data.append(AlcoholEntry(level: gramsOfAlcohol + lastGrams - eliminationPerSecond * timeSpace,
                                 date: Date(),
                                 addedByUser: addedByUser))
        if data.count == 1 {
            startTracking()
        }
    }
    
    private func setChartColor(_ totalOfAlcohol: Double) {
        if totalOfAlcohol < 0.4 {
            chartColor = .green
        } else if totalOfAlcohol > 0.8 {
            chartColor = .red
        } else {
            chartColor = .orange
        }
    }
    
    func startTracking() {
        timer?.cancel()
        timer = Timer.publish(every: timeSpace, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.addEntry(0, addedByUser: false)
                if self.data.count > 150 {
                    self.upShiftGranularity()
                }
            }
    }
    
    @MainActor
    private func upShiftGranularity() {
        var newData: [AlcoholEntry] = []
        for (index, entry) in data.enumerated() {
            if index % 3 == 0 || entry.addedByUser {
                newData.append(entry)
            }
        }
        
        self.data = newData
        startTracking()
    }
    
    func stopTracking() {
        timer?.cancel()
        timer = nil
    }
}
