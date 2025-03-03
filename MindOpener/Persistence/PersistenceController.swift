//
//  PersistenceController.swift
//  MindOpener
//
//  Created by Vnt0n on 03/03/2025.
//

import SwiftData
import Foundation

@MainActor
struct PersistenceController {
    static let shared = PersistenceController()

    let container: ModelContainer

    init(inMemory: Bool = false) {
        do {
            // Initialiser le conteneur avec ton modèle (ici MindOpenerItem)
            container = try ModelContainer(for: MindOpenerItem.self)
            
            // Accès au contexte principal (mainContext) sur le MainActor
            let context = container.mainContext
            
            // Création d'un FetchDescriptor pour récupérer les MindOpenerItem triés par "order"
            let fetchDescriptor = FetchDescriptor<MindOpenerItem>(
                sortBy: [SortDescriptor(\.order, order: .forward)]
            )
            
            let existingItems = try context.fetch(fetchDescriptor)
            if existingItems.isEmpty {
                // Prépopulation de la base avec les données de HardCodedData
                for item in HardCodedData.items {
                    context.insert(item)
                }
                try context.save()
            }
        } catch {
            fatalError("Failed to initialize SwiftData: \(error)")
        }
    }
}

func resetDataIfNeeded(context: ModelContext) {
    var AppVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }
    let defaults = UserDefaults.standard
    let previousAppVersion = defaults.string(forKey: "ContentVersion")
    print("Current content version: \(AppVersion)")
    print("Stored content version: \(previousAppVersion ?? "nil")")
    if previousAppVersion != AppVersion {
        // Supprimer tous les objets existants
        let fetchDescriptor = FetchDescriptor<MindOpenerItem>(sortBy: [SortDescriptor(\.order, order: .forward)])
        do {
            let itemsToDelete = try context.fetch(fetchDescriptor)
            for item in itemsToDelete {
                context.delete(item)
            }
            try context.save()
            // Insérer les nouveaux items à partir de HardCodedData
            for item in HardCodedData.items {
                context.insert(item)
            }
            try context.save()
            defaults.set(AppVersion, forKey: "ContentVersion")
        } catch {
            print("Erreur lors de la réinitialisation des données : \(error)")
        }
    }
}
