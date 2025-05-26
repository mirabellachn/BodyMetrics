//
//  BMIView.swift
//  BodyMetrics
//
//  Created by Mirabella on 25/05/25.
//

import SwiftUI

struct BMIView: View {
    @State private var weight: String = ""
    @AppStorage("userHeight") private var userHeight: Double = 165
    @State private var bmi: Double?
    @State private var category: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Weight in KG")) {
                    TextField("45 kg", text: $weight)
                        .keyboardType(.decimalPad)
                }

                Section(header: Text("Height in cm")) {
                    Text("\(Int(userHeight)) cm")
                    // Kalau mau tambah tombol edit, bisa di sini arahkan ke SettingsView
                }

                Button("Hitung BMI") {
                    calculateBMI()
                }

                if let bmi = bmi {
                    Section(header: Text("Hasil")) {
                        Text(String(format: "BMI: %.2f", bmi))
                        Text("Kategori: \(category)")
                            .foregroundColor(.blue)
                    }
                }
            }
            .navigationTitle("BMI Calculator")
        }
    }

    func calculateBMI() {
        guard let weight = Double(weight), userHeight > 0 else {
            bmi = nil
            category = "Input tidak valid"
            return
        }

        let heightM = userHeight / 100
        let result = weight / (heightM * heightM)
        bmi = result

        switch result {
        case ..<18.5:
            category = "Underweight"
        case 18.5..<25:
            category = "Normal weight"
        case 25..<30:
            category = "Overweight"
        default:
            category = "Obese"
        }
    }
}


#Preview {
    BMIView()
}
