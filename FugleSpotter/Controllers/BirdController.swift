import SwiftUI
import FirebaseFirestore
import CoreLocation

@Observable
@MainActor
class BirdController {
    enum FilterState {
        case all
        case bySpecies(Bird.BirdSpecies)
        case grouped
    }
    
    var birds = [Bird]()
    var filterState: FilterState = .all
    
    var filteredBirds: [Bird] {
        switch filterState {
        case .all:
            return birds
        case .bySpecies(let species):
            return birds.filter { $0.species == species }
        case .grouped:
            return birds
        }
    }
    
    @ObservationIgnored
    private var firebaseService = FirebaseService()
    
    init() {
        setupFirebaseListener()
    }
    
    private func setupFirebaseListener() {
        firebaseService.setupListener { [weak self] fetchedBirds in
            self?.birds = fetchedBirds
        }
    }
    
    func delete(bird: Bird) async throws {
        try await firebaseService.deleteBird(bird: bird)
    }
    
    func saveBirdSpotting(
            species: Bird.BirdSpecies,
            note: String,
            location: CLLocation,
            imageData: Data?
        ) async throws {
            let geoPoint = GeoPoint(latitude: location.coordinate.latitude,
                                   longitude: location.coordinate.longitude)
            let compressedImage = Bird.compressImage(imageData)
            
            let bird = Bird(
                species: species,
                date: Date(),
                location: geoPoint,
                note: note,
                image: compressedImage
            )
            
            try await Task { @MainActor in
                try firebaseService.addBird(bird: bird)
            }.value
        }
    }
