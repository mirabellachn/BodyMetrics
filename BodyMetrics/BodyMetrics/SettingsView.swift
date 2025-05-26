//
//  SettingView.swift
//  BodyMetrics
//
//  Created by Mirabella on 26/05/25.
//
import SwiftUI

struct SettingsView: View {
    @AppStorage("userHeight") private var userHeight: Double = 165
    @AppStorage("userAge") private var userAge: Int = 25
    @AppStorage("userGender") private var userGender: String = "Male"
    
    @State private var heightText: String = ""
    @Environment(\.dismiss) private var dismiss
    
    let genders = ["Male", "Female", "Other"]
    let ageRange = 1...120
    
    var body: some View {
        Form {
            Section(header: Text("Gender")) {
                Picker("Select Gender", selection: $userGender) {
                    ForEach(genders, id: \.self) { gender in
                        Text(gender)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            Section(header: Text("Age")) {
                Picker("Select Age", selection: $userAge) {
                    ForEach(ageRange, id: \.self) { age in
                        Text("\(age) years").tag(age)
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 150)
            }
            
            Section(header: Text("Height (cm)")) {
                TextField("Enter your height", text: $heightText)
                    .keyboardType(.decimalPad)
                    .onAppear {
                        heightText = String(format: "%.0f", userHeight)
                    }
            }
            
            Section {
                HStack {
                    Spacer()
                    Button("Save Settings") {
                        if let height = Double(heightText), height > 0 {
                            userHeight = height
                            dismiss()
                        }
                    }
                    Spacer()
                }
            }
        }
        .navigationTitle("Settings")
    }
}


#Preview {
    SettingsView()
}
