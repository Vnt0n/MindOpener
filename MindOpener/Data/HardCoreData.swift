//
//  HardCoreData.swift
//  MindOpener
//
//  Created by Vnt0n on 01/03/2025.
//

// HardCodedData.swift

import Foundation

struct HardCodedData {
    static let quotes: [Quote] = [
        Quote(
            text: "Art is what makes life more interesting than Art",
            details: "Detailed text",
            author: "Robert Filliou",
            authorBirthYear: 1926,
            authorDeathYear: 1987,
            authorImageName: "RobertFilliou",
            wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/Robert_Filliou")!
        ),
        // Ajoute d'autres quotes ici si besoin
    ]
}
