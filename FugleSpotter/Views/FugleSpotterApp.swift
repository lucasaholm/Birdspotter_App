//
//  FugleSpotterApp.swift
//  FugleSpotter
//
//  Created by Lucas Holm on 09/12/2024.
//

import SwiftUI
import FirebaseCore

@main
struct FugleSpotterApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(LocationManager())
                .environment(BirdController())
        }
    }
}
