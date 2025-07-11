import UIKit
import SwiftUI

struct BirdRowView: View {
    let bird: Bird
    
    private var birdImage: Image {
        if let imageData = bird.image,
           let uiImage = UIImage(data: imageData) {
            return Image(uiImage: uiImage)
        }
        return Image(systemName: "bird.fill")
    }
    
    var body: some View {
        NavigationLink(destination: BirdDetailView(bird: bird)) {
            HStack {
                birdImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(bird.species.rawValue.capitalized)
                        .font(.headline)
                    
                    if !bird.note.isEmpty {
                        Text(bird.note)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Text(bird.date.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.leading, 8)
            }
            .padding(.vertical, 4)
        }
    }
}
