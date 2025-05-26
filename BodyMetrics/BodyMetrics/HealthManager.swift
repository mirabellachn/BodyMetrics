//
//  HealthManager.swift
//  BodyMetrics
//
//  Created by Mirabella on 26/05/25.
//

import HealthKit

class HealthManager: ObservableObject {
    private let healthStore = HKHealthStore()

    // Request izin ke HealthKit
    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else { return }

        let toRead: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .bodyMass)!,
            HKObjectType.quantityType(forIdentifier: .bodyMassIndex)!
        ]

        let toWrite: Set<HKSampleType> = [
            HKObjectType.quantityType(forIdentifier: .bodyMass)!,
            HKObjectType.quantityType(forIdentifier: .bodyMassIndex)!
        ]

        healthStore.requestAuthorization(toShare: toWrite, read: toRead) { success, error in
            if let error = error {
                print("HealthKit authorization error: \(error.localizedDescription)")
            } else {
                print("HealthKit authorization success: \(success)")
            }
        }
    }

    // Simpan berat ke HealthKit
    func saveWeight(_ weight: Double, date: Date) {
        guard let weightType = HKQuantityType.quantityType(forIdentifier: .bodyMass) else { return }

        let quantity = HKQuantity(unit: .gramUnit(with: .kilo), doubleValue: weight)
        let sample = HKQuantitySample(type: weightType, quantity: quantity, start: date, end: date)

        healthStore.save(sample) { success, error in
            if let error = error {
                print("Failed to save weight: \(error.localizedDescription)")
            } else {
                print("Weight saved to HealthKit.")
            }
        }
    }

    // Ambil data berat terbaru dari HealthKit
    func fetchLatestWeight(completion: @escaping (Double?) -> Void) {
        guard let weightType = HKQuantityType.quantityType(forIdentifier: .bodyMass) else {
            DispatchQueue.main.async { completion(nil) }
            return
        }

        let sort = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(
            sampleType: weightType,
            predicate: nil,
            limit: 1,
            sortDescriptors: [sort]
        ) { _, samples, _ in
            guard let sample = samples?.first as? HKQuantitySample else {
                DispatchQueue.main.async { completion(nil) }
                return
            }

            let weight = sample.quantity.doubleValue(for: .gramUnit(with: .kilo))
            DispatchQueue.main.async {
                completion(weight)
            }
        }

        healthStore.execute(query)
    }
}
