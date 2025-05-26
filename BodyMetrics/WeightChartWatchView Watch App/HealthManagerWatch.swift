//
//  HealthManagerWatch.swift
//  WeightChartWatchView Watch App
//
//  Created by Mirabella on 26/05/25.
//

import HealthKit
import Combine

class HealthManagerWatch: ObservableObject {
    private let healthStore = HKHealthStore()
    @Published var weights: [HKQuantitySample] = []

    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else {
            print("Health data not available on this device.")
            return
        }

        let weightType = HKObjectType.quantityType(forIdentifier: .bodyMass)!
        
        healthStore.requestAuthorization(toShare: [], read: [weightType]) { success, error in
            if let error = error {
                print("HealthKit authorization error: \(error.localizedDescription)")
                return
            }

            if success {
                self.fetchWeights()
            } else {
                print("HealthKit authorization was not granted.")
            }
        }
    }

    func fetchWeights() {
        guard let weightType = HKObjectType.quantityType(forIdentifier: .bodyMass) else {
            print("Weight type is unavailable.")
            return
        }

        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        let query = HKSampleQuery(sampleType: weightType, predicate: nil, limit: 50, sortDescriptors: [sortDescriptor]) { query, samples, error in
            if let error = error {
                print("Error fetching weights: \(error.localizedDescription)")
                return
            }

            guard let samples = samples as? [HKQuantitySample] else {
                print("No weight samples found.")
                return
            }

            DispatchQueue.main.async {
                self.weights = samples
            }
        }

        healthStore.execute(query)
    }
}

