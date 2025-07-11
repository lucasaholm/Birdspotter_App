//
//  FlatBirdListView.swift
//  FugleSpotter
//
//  Created by Lucas Holm on 10/12/2024.
//
import SwiftUI

struct FlatBirdListView: View {
    let birds: [Bird]
    let onDelete: (Bird) -> Void
    
    var body: some View {
        List(birds) { bird in
            BirdRowView(bird: bird)
                .swipeActions { deleteButton(for: bird) }
        }
    }
    
    private func deleteButton(for bird: Bird) -> some View {
        Button(role: .destructive) {onDelete(bird) } label: {
            Label("Delete", systemImage: "trash")
        }
    }
}
