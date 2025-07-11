//
//  DetailRowView.swift
//  FugleSpotter
//
//  Created by Lucas Holm on 09/12/2024.
//
import SwiftUI

struct DetailRowView : View {
    let title: String
    let detail: String
      
    var body : some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
            Text(detail)
                .foregroundColor(.secondary)
        }
    }
}
