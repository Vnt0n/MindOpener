//
//  MindOpenerApp.swift
//  MindOpener
//
//  Created by Vnt0n on 01/03/2025.
//

import SwiftUI
import SwiftData

@main
struct MindOpenerApp: App {
    let persistenceController = PersistenceController.shared
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    init() {
        // Votre configuration existante...
        if UITraitCollection.current.userInterfaceStyle == .light {
            UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self]).currentPageIndicatorTintColor = UIColor.black
            UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self]).pageIndicatorTintColor = UIColor.gray
        }
        // Réinitialiser les données si besoin
        resetDataIfNeeded(context: persistenceController.container.mainContext)
    }

    var body: some Scene {
        WindowGroup {
            MainView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .modelContainer(persistenceController.container)
        }
    }
}
