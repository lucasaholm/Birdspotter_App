import SwiftUI
import CoreLocation

struct ContentView: View {
    @State private var showingAddObservation = false
    @State private var birdToDelete: Bird?
    @State private var isDeleteAlertShowing = false
    @State private var showingQuoteView = true
    @Environment(LocationManager.self) var locationManager
    @Environment(BirdController.self) var birdController
    
    // grupperede fugle efter art
    var groupedBirds: [(Bird.BirdSpecies, [Bird])] {
        Dictionary(grouping: birdController.filteredBirds) { $0.species }
            .map { ($0.key, $0.value.sorted { $0.date > $1.date }) }
            .sorted { $0.0.rawValue < $1.0.rawValue }
    }
    
    var body: some View {
        NavigationView {
            Group {
                switch birdController.filterState {
                case .grouped:
                    GroupedBirdListView(groupedBirds: groupedBirds, onDelete: { bird in
                        confirmDelete(bird)
                    })
                    
                case .all, .bySpecies:
                    FlatBirdListView(birds: birdController.filteredBirds, onDelete: { bird in
                        confirmDelete(bird)
                    })
                }
            }
            .navigationTitle("My Observations")
            .navigationBarItems(leading: addObservationButton, trailing: filterMenu)
            .sheet(isPresented: $showingAddObservation) {
                AddObservationView()
            }
            .alert("Delete observation?", isPresented: $isDeleteAlertShowing) {
                deleteAlertButtons()
            }
            .fullScreenCover(isPresented: $showingQuoteView) {
                QuoteView(isPresented: $showingQuoteView)
            }
        }
    }
    
    private var addObservationButton: some View {
        Button(action: { showingAddObservation = true }) {
            Image(systemName: "plus.circle.fill").imageScale(.large)
        }
    }
    
    private var filterMenu: some View {
        Menu {
            Button("All Birds") {birdController.filterState = .all }
            Button("Group by Species") {birdController.filterState = .grouped }
            Menu("Filter by species") {
                ForEach(Bird.BirdSpecies.allCases, id: \.self) { species in
                    Button(species.rawValue.capitalized) {
                        birdController.filterState = .bySpecies(species)
                    }
                }
            }
        } label: {
            Image(systemName: "line.3.horizontal.decrease.circle").imageScale(.large)
        }
    }
    
    
    private func confirmDelete(_ bird: Bird) {
        birdToDelete = bird
        isDeleteAlertShowing = true
    }
    
    private func deleteAlertButtons() -> some View {
        VStack {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let bird = birdToDelete {
                    Task {
                        do {
                            try await birdController.delete(bird: bird)
                        } catch {
                            print("Error deleting bird: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
}
    #Preview {
        ContentView().environment(LocationManager()).environment(BirdController())
    }

