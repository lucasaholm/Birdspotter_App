import Foundation
import FirebaseFirestore
import UIKit

struct Bird: Codable, Identifiable {
    @DocumentID var id: String?
    let species: BirdSpecies
    let date: Date
    let location: GeoPoint
    let note: String
    let image: Data?
    
    enum BirdSpecies: String, Codable, CaseIterable {
        case sparrow
        case bluebird
        case eagle
        case robin
        case hawk
        case other
    }
    
    static func compressImage(_ imageData: Data?) -> Data? {
        guard let imageData = imageData,
              let uiImage = UIImage(data: imageData) else {
            return nil
        }
        return uiImage.jpegData(compressionQuality: 0.25)
    }
}
