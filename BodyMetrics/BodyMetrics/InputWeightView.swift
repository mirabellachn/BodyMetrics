//
//  InputWeightView.swift
//  BodyMetrics
//
//  Created by Mirabella on 25/05/25.
//

import SwiftUI
import SwiftData

struct InputWeightView: View {
    @Environment(\.modelContext) private var context
    @State private var selectedDate: Date = Date()
    @State private var weightText: String = ""
    @State private var showConfirmation = false

    var body: some View {
        Form {
            Section(header: Text("Date")) {
                DatePicker("Select a date", selection: $selectedDate, displayedComponents: .date)
            }

            Section(header: Text("Your Weight (kg)")) {
                TextField("e.g. 60.5", text: $weightText)
                    .keyboardType(.decimalPad)
            }

            Section {
                HStack {
                    Spacer()
                    Button("Add to My Journey") {
                        saveWeight()
                    }
                    Spacer()
                }
            }
        }

        .navigationTitle("Log Your Weight")
        .alert("Entry Saved 🎉", isPresented: $showConfirmation) {
            Button("Awesome!", role: .cancel) { }
        }
    }

    func saveWeight() {
        guard let weight = Double(weightText), weight > 0 else { return }

        let newEntry = WeightEntry(date: selectedDate, weight: weight)
        context.insert(newEntry)

        do {
            try context.save()
            weightText = ""
            selectedDate = Date()
            showConfirmation = true
        } catch {
            print("Error saving data: \(error.localizedDescription)")
        }
    }
}

#Preview {
    NavigationStack {
        InputWeightView()
    }
}
