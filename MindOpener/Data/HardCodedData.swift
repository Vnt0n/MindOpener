//
//  HardCodedData.swift
//  MindOpener
//
//  Created by Vnt0n on 06/03/2025.
//


import Foundation

struct HardCodedData {
    static let items: [MindOpenerItem] = [
        {
            let item = MindOpenerItem(
                order: 0,
                itemType: "quote",
                details: NSLocalizedString("Un", comment: "Détails de la citation"),
                author: "Robert Filliou",
                authorBirthYear: 1926,
                authorDeathYear: 1987,
                authorImageName: "RobertFilliou",
                wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/Robert_Filliou"),
                text: NSLocalizedString("Art is what makes life more interesting than Art", comment: "Citation principale"),
                title: "",    // non utilisé pour une citation
                year: "",     // non utilisé pour une citation
                imageName: "" // non utilisé pour une citation
            )
            return item
        }(),
        {
            let item = MindOpenerItem(
                order: 1,
                itemType: "artwork",
                details: NSLocalizedString("Quatre", comment: "Détails de l'œuvre"),
                author: "Robert Filliou",
                authorBirthYear: 1926,
                authorDeathYear: 1987,
                authorImageName: "RobertFilliou",
                wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/Robert_Filliou"),
                text: "", // non utilisé pour une œuvre
                title: NSLocalizedString("Time in a Nutshell", comment: "Titre de l'œuvre"),
                year: "1987", // à compléter si besoin
                imageName: "Nutshell"
            )
            return item
        }()
    ]
}
