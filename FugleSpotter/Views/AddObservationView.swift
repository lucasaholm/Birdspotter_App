//  AddObservationView.swift
//  FugleSpotter
//
//  Created by Lucas Holm on 09/12/2024.
//
import SwiftUI
import CoreLocation
import PhotosUI
import FirebaseFirestore

struct AddObservationView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedSpecies = Bird.BirdSpecies.sparrow
    @State private var note = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isSaving = false
    @State private var userLocation: CLLocation? = nil
    
    @Environment(BirdController.self) var birdController
    @Environment(LocationManager.self) var locationManager
    
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImageData: Data?
    
    var birdImage: Image {
        if let imageData = selectedImageData,
           let uiImage = UIImage(data: imageData) {
            return Image(uiImage: uiImage)
        }
        return Image(systemName: "bird.fill")
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Bird Spotter")
                    .font(.title)
                
                VStack{
                    birdImage
                        .resizable()
                        .frame(width: 150, height: 150)
                        .background(Color.black.opacity(0.2))
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                    
                    PhotosPicker(
                        selection: $selectedPhoto,
                        matching: .images,
                        photoLibrary: .shared()) {
                            Label("Select photo", systemImage: "photo")
                        }
                }.onChange(of: selectedPhoto) {oldValue, newValue in
                    Task {
                        if let data = try? await newValue?.loadTransferable(type: Data.self) {
                            selectedImageData = data
                        }
                    }
                }
                
                
                Picker("Bird Specie", selection: $selectedSpecies) {
                    ForEach(Bird.BirdSpecies.allCases, id: \.self) { species in
                        Text(species.rawValue.capitalized)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                TextField("Write down your notes", text: $note)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Save Bird Observation") {
                    saveBirdSpotting()
                }
                .disabled(note.isEmpty)
            }
            .padding()
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Message"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK")) {
                        if !note.isEmpty {
                            dismiss()
                        }
                    }
                )
            }
            .task {
                do {
                    userLocation = try await locationManager.getCurrentLocation()
                    print("Location received: \(String(describing: userLocation))")
                } catch {
                    print("Error fetching location: \(error)")
                    alertMessage = "Locationpermission required to save bird observation."
                    showingAlert = true
                }
            }
            .navigationBarItems(trailing: Button("Close") {
                dismiss()
            })
        }
    }
    
    private func saveBirdSpotting() {
        guard let location = userLocation else {
            alertMessage = "Couldn't fetch location"
            showingAlert = true
            return
        }
        
        Task {
            do {
                try await birdController.saveBirdSpotting(
                    species: selectedSpecies,
                    note: note,
                    location: location,
                    imageData: selectedImageData
                )
                
                
                alertMessage = "Bird observation saved successfully"
                showingAlert = true
                
                
                // Nulstiller felterne efterfølgende
                note = ""
                selectedImageData = nil
                
            } catch {
                alertMessage = "Error saving bird: \(error.localizedDescription)"
                showingAlert = true
            }
        }
    }
}
