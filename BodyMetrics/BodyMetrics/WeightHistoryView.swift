//
//  WeightHistoryView.swift
//  BodyMetrics
//
//  Created by Mirabella on 26/05/25.
//

import SwiftUI
import SwiftData

struct WeightHistoryView: View {
    @Query(sort: \WeightEntry.date, order: .reverse) var entries: [WeightEntry]  // newest first
    @Environment(\.modelContext) private var context

    var body: some View {
        List {
            if entries.isEmpty {
                Text("No weight records yet.")
                    .foregroundColor(.gray)
            } else {
                ForEach(entries) { entry in
                    HStack {
                        Text(entry.date, format: .dateTime.day().month().year())
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(String(format: "%.1f kg", entry.weight))
                            .font(.headline)
                    }
                }
                .onDelete(perform: deleteItems)
            }
        }
        .navigationTitle("Weight History")
        .toolbar {
            EditButton()
        }
    }

    func deleteItems(at offsets: IndexSet) {
        offsets.map { entries[$0] }.forEach(context.delete)
        do {
            try context.save()
        } catch {
            print("Failed to delete entry: \(error.localizedDescription)")
        }
    }
}

#Preview {
    WeightHistoryView()
}

