//
//  FavoritePlacesApp.swift
//  Shared
//
//  Created by Jemil Pepena on 22/5/2022.
//

import SwiftUI

@main
struct FavoritePlacesApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
