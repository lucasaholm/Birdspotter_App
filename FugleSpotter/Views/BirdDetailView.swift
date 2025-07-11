import MapKit
import SwiftUI
struct BirdDetailView: View {
    let bird: Bird
    @Environment(LocationManager.self) var locationManager
    @State private var cameraPosition: MapCameraPosition
    @Environment(BirdController.self) var birdController
    
    init(bird: Bird) {
        self.bird = bird
        let birdCoordinate = CLLocationCoordinate2D(
            latitude: bird.location.latitude,
            longitude: bird.location.longitude
        )
        
        _cameraPosition = State(initialValue: .camera(MapCamera(
            centerCoordinate: birdCoordinate,
            distance: 10000,
            heading: 0,
            pitch: 0
        )))
    }
    private var birdImage: Image {
        if let imageData = bird.image,
           let uiImage = UIImage(data: imageData) {
            return Image(uiImage: uiImage)
        }
        return Image(systemName: "bird.fill")
    }
    
    var body: some View {
        VStack() {
            Map(position: $cameraPosition) {
                UserAnnotation()
                ForEach(birdController.birds) { observedBird in
                    Annotation(
                        observedBird.species.rawValue,
                        coordinate: CLLocationCoordinate2D(
                            latitude: observedBird.location.latitude,
                            longitude: observedBird.location.longitude
                        )
                    ) {
                        Image(systemName: "bird.fill")
                            .foregroundStyle(observedBird.id == bird.id ? .red : .blue)
                            .padding(8)
                            .background(
                                Circle()
                                    .fill(.white)
                            )
                    }
                }
            }
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
            }
            .frame(height: 300)
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    birdImage
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal)
                    Text(bird.species.rawValue.capitalized)
                        .font(.title)
                        .bold()
                    
                    Group {
                        DetailRowView(title: "Observed", detail: bird.date.formatted(date: .abbreviated, time: .shortened))
                        DetailRowView(title: "Location", detail: "Lat: \(bird.location.latitude), Lon: \(bird.location.longitude)")
                        if !bird.note.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Notes")
                                    .font(.headline)
                                Text(bird.note)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
