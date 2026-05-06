//
//  AlcoholTrackerView.swift
//  Beer
//
//  Created by Fernando Santos de Souza on 08/04/26.
//

import SwiftUI
import Charts

struct AlcoholTrackerView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.scenePhase) var scenePhase
    @StateObject var vm = AlcoholTrackerViewModel()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            header()
            
            trackerChart()
            
            Group {
                DrinkSelector(alcoholPercentage: $vm.currentAlcoholPercentage,
                              selectedDrink: $vm.selectedDrink)
                
                VolumeSliderView(volumeSelected: $vm.currentDrinkValue)
                
                CustomButton(color: .cyan, icon: "plus", text: "Drink") {
                    vm.addEntry()
                }
                
                CustomButton(isDisabled: !vm.isDrinking, color: .red, icon: "xmark.circle", text: "Stop") {
                    vm.stopTracking(context: context)
                }
            }
            .padding(.horizontal)
        }
        .onChange(of: scenePhase) { _, newPhase in
            switch newPhase {
            case .background:
                vm.saveSnapshot(context: context)
                break
            case .active:
                vm.restoreSnapshot(context: context)
                break
            case .inactive:
                break
            @unknown default:
                break
            }
        }
    }
    
    @ViewBuilder
    private func header() -> some View {
        if vm.isDrinking {
            DrinkCounter(counter: vm.drinkCounter,
                         totalGrams: vm.totalAmoutIngested)
                .padding(.horizontal)
        } else {
            Rectangle()
                .foregroundStyle(.clear)
                .frame(height: 40)
        }
    }
    
    private func trackerChart() -> some View {
        VStack(alignment: .center) {
            Text("Grams of Alcool in the Blood")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.cyan)
            
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
