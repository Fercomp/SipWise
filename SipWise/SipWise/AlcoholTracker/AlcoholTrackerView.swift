//
//  AlcoholTrackerView.swift
//  Beer
//
//  Created by Fernando Santos de Souza on 08/04/26.
//

import SwiftUI
import Charts

struct AlcoholTrackerView: View {
    @StateObject var vm = AlcoholTrackerViewModel()
    
    var body: some View {
        VStack(spacing: 8) {
            DrinkCounter(counter: $vm.drinkCounter)
                .padding(.horizontal)
            
            trackerChart()
            
            Group {
                DrinkSelector(selectedDrink: $vm.selectedDrink,
                              drinkTotalVolume: $vm.currentDrinkValue)
                
                CustomButton(color: .cyan, icon: "plus", text: "Drink") {
                    vm.addEntry()
                }
                
                CustomButton(isDisabled: vm.isDrinking, color: .red, icon: "xmark.circle", text: "Stop") {
                    vm.stopTracking()
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func trackerChart() -> some View {
        VStack(alignment: .center) {
            Text("Gramas de Álcool no Sangue")
                .font(.callout).bold()
            
            Chart {
                ForEach(vm.alcoholEntries) { ponto in
                    LineMark(
                        x: .value("Hora", ponto.date),
                        y: .value("Nível", ponto.level)
                    )
                    .interpolationMethod(.monotone)
                    .foregroundStyle(vm.chartColor)
                }
                
                RuleMark(y: .value("Limite", vm.threshold))
                    .lineStyle(StrokeStyle(lineWidth: 2, dash: [10]))
                    .foregroundStyle(.red)
                            
            }
            .frame(height: 300)
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisGridLine()
                    if let nivel = value.as(Double.self) {
                        AxisValueLabel {
                            Text("\(nivel, specifier: "%.1f") g")
                        }
                    }
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .hour)) { _ in
                    AxisValueLabel(format: .dateTime.hour(.defaultDigits(amPM: .abbreviated)))
                    AxisGridLine()
                }
            }
        }
        .padding()
    }
}

#Preview {
    AlcoholTrackerView()
}
