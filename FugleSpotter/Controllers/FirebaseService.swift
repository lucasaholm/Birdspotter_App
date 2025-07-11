//
//  FirebaseService.swift
//  FugleSpotter
//
//  Created by Lucas Holm on 09/12/2024.
//
import Foundation
import FirebaseFirestore

struct FirebaseService {
    private let dbBirdCollection = Firestore.firestore().collection("birds")
    private var listener: ListenerRegistration?
    
    mutating func setupListener(callback: @escaping ([Bird]) -> Void) {
        listener = dbBirdCollection
            .order(by: "date", descending: true)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error listening to updates: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    callback([])
                    return
                }
                
                let birds = documents.compactMap { try? $0.data(as: Bird.self) }
                callback(birds)
            }
    }
    
    mutating func tearDownListener() {
        listener?.remove()
        listener = nil
    }
    
    func addBird(bird: Bird) throws {
        do {
            try dbBirdCollection.addDocument(from: bird)
        } catch {
            throw error
        }
    }
    
    func deleteBird(bird: Bird) async throws {
        guard let documentID = bird.id else {
            throw NSError(domain: "FirebaseService",
                         code: -1,
                         userInfo: [NSLocalizedDescriptionKey: "Document ID is missing"])
        }
        try await dbBirdCollection.document(documentID).delete()
    }
}
