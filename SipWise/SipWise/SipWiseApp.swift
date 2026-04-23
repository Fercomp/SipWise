//
//  SipWiseApp.swift
//  SipWise
//
//  Created by Fernando on 2026/4/22.
//

import SwiftUI

@main
struct SipWiseApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                AlcoholTrackerView()
                    .tabItem { Label("Tracker", systemImage: "chart.line.uptrend.xyaxis") }
                
                HistoryView()
                    .tabItem { Label("History", systemImage: "calendar") }
            }
        }
    }
}
