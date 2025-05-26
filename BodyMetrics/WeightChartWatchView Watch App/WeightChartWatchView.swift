//
//  WeightChartWatchView.swift
//  WeightChartWatchView Watch App
//
//  Created by Mirabella on 26/05/25.
//

import SwiftUI
import Charts

struct WeightChartWatchView: View {
    @StateObject private var healthManager = HealthManagerWatch()

    var body: some View {
        VStack {
            if healthManager.weights.isEmpty {
                Text("No data yet")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                Chart {
                    ForEach(healthManager.weights, id: \.uuid) { sample in
                        let weight = sample.quantity.doubleValue(for: .gramUnit(with: .kilo))
                        LineMark(
                            x: .value("Date", sample.startDate),
                            y: .value("Weight (kg)", weight)
                        )
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .chartXScale(domain: .automatic)
                .chartYScale(domain: .automatic(includesZero: false))
                .frame(height: 150)
            }
        }
        .padding()
        .onAppear {
            healthManager.requestAuthorization()
        }
        .navigationTitle("Weight Chart")
    }
}

#Preview {
    WeightChartWatchView()
}
