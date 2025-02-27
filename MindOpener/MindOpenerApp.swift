//
//  MindOpenerApp.swift
//  MindOpener
//
//  Created by Vnt0n on 27/02/2025.
//

import SwiftUI
import SwiftData

@main
struct MindOpenerApp: App {
    // On crée le ModelContainer en prenant en compte ton modèle "Quote"
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Quote.self // <-- On remplace Item.self par Quote.self
        ])
        
        // Tu peux conserver la configuration que tu avais
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            return try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainQuoteView()
                // On injecte le modelContainer pour que la vue (et ses enfants)
                // puissent accéder à la base SwiftData
                .modelContainer(sharedModelContainer)
                .statusBar(hidden: true)
        }
    }
}
