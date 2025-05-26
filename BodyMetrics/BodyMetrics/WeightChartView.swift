//
//  WeightChartView.swift
//  BodyMetrics
//
//  Created by Mirabella on 25/05/25.
//

import SwiftUI
import Charts
import SwiftData

struct WeightChartView: View {
    @Query(sort: \WeightEntry.date) var entries: [WeightEntry]
    @Environment(\.modelContext) private var context

    let heightInCM: Double = UserDefaults.standard.double(forKey: "userHeight") == 0 ? 165 : UserDefaults.standard.double(forKey: "userHeight")

    @State private var showResetAlert = false

    var body: some View {
        VStack {
            if let latest = entries.last {
                let bmi = calculateBMI(weight: latest.weight)
                VStack(spacing: 4) {
                    Text("Current BMI: \(String(format: "%.2f", bmi))")
                        .font(.title2.bold())
                    Text("Category: \(bmiCategory(bmi))")
                        .foregroundColor(.blue)
                }
                .padding(.bottom, 16)
            }

            Chart {
                ForEach(entries) { entry in
                    LineMark(
                        x: .value("Date", entry.date),
                        y: .value("Weight", entry.weight)
                    )
                }
            }
            .chartYScale(domain: .automatic(includesZero: false))
            .frame(height: 300)

            Button(role: .destructive) {
                showResetAlert = true
            } label: {
                Text("Clear All Data")
                    .foregroundColor(.red)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }
            .padding(.top, 20)
            .alert("Are you sure you want to delete all weight entries?", isPresented: $showResetAlert) {
                Button("Delete", role: .destructive, action: resetData)
                Button("Cancel", role: .cancel) {}
            }
        }
        .padding()
        .navigationTitle("Progress Chart")
    }

    func resetData() {
        for entry in entries {
            context.delete(entry)
        }

        do {
            try context.save()
        } catch {
            print("Error resetting data: \(error.localizedDescription)")
        }
    }

    func calculateBMI(weight: Double) -> Double {
        let heightM = heightInCM / 100
        return weight / (heightM * heightM)
    }

    func bmiCategory(_ bmi: Double) -> String {
        switch bmi {
        case ..<18.5: return "Underweight"
        case 18.5..<25: return "Normal"
        case 25..<30: return "Overweight"
        default: return "Obese"
        }
    }
}

#Preview {
    WeightChartView()
}
