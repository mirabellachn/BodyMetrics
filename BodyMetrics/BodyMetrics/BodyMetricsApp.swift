//
//  BodyMetricsApp.swift
//  BodyMetrics
//
//  Created by Mirabella on 24/05/25.
//

import SwiftUI

@main
struct BodyMetricsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: WeightEntry.self) // <-- ini penting dan sudah ada
    }
}
