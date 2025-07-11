import CoreLocation

@Observable
@MainActor
class LocationManager {
    private let manager: CLLocationManager
    
    init() {
        self.manager = CLLocationManager()
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.manager.requestWhenInUseAuthorization()
    }
    
    func getCurrentLocation() async throws -> CLLocation {
        guard let location = manager.location else {
            throw LocationError.locationUnavailable
        }
        return location
    }
    
    enum LocationError: Error {
        case locationUnavailable
        
        var localizedDescription: String {
            switch self {
            case .locationUnavailable:
                return "Could not access location. Please check your location permissions."
            }
        }
    }
}

