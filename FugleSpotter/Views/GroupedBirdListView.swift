//
//  GroupedBirdListView.swift
//  FugleSpotter
//
//  Created by Lucas Holm on 10/12/2024.
//

import SwiftUI

struct GroupedBirdListView: View {
    let groupedBirds: [(Bird.BirdSpecies, [Bird])]
    let onDelete: (Bird) -> Void
    
    var body: some View {
        List {
            ForEach(groupedBirds, id:\.0) {species, birds in
                Section(header: Text(species.rawValue.capitalized)) {
                    ForEach(birds) { bird in
                        BirdRowView(bird: bird)
                            .swipeActions {deleteButton(for: bird) }
                    }
                }
            }
        }
    }
    
    private func deleteButton(for bird: Bird) -> some View {
        Button(role: .destructive) { onDelete(bird) } label: {
            Label("Delete", systemImage: "trash")
        }
    }
}
