//
//  ContentView.swift
//  BodyMetrics
//
//  Created by Mirabella on 24/05/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var showSettings = false

    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                // Tab 1: Log Weight
                InputWeightView()
                    .tabItem {
                        Label("Log Weight", systemImage: "plus.circle")
                    }
                    .tag(0)

                // Tab 2: View Progress Chart
                WeightChartView()
                    .tabItem {
                        Label("Progress", systemImage: "chart.line.uptrend.xyaxis")
                    }
                    .tag(1)
                
                // Tab 3: Weight Entry History
                WeightHistoryView()
                    .tabItem {
                        Label("History", systemImage: "list.bullet")
                    }
                    .tag(2)

                // Tab 4: BMI Calculator
                BMIView()
                    .tabItem {
                        Label("BMI Tool", systemImage: "scalemass")
                    }
                    .tag(3)
            }
            .navigationTitle(titleForTab(selectedTab))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                NavigationStack {
                    SettingsView()
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button("Close") {
                                    showSettings = false
                                }
                            }
                        }
                }
            }
        }
    }

    func titleForTab(_ tab: Int) -> String {
        switch tab {
        case 0: return "Log Your Weight"
        case 1: return "Your Progress Chart"
        case 2: return "Weight History"
        case 3: return "BMI Calculator"
        default: return "Body Metrics"
        }
    }
}

#Preview {
    ContentView()
}
