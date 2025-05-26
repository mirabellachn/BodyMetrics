//
//  WeightEntry.swift
//  BodyMetrics
//
//  Created by Mirabella on 25/05/25.
//

import Foundation
import SwiftData

@Model
class WeightEntry {
    var date: Date
    var weight: Double

    init(date: Date, weight: Double) {
        self.date = date
        self.weight = weight
    }
}
