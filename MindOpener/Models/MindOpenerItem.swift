//
//  MindOpenerItem.swift
//  MindOpener
//
//  Created by Vnt0n on 03/03/2025.
//

import SwiftData
import Foundation

@Model
class MindOpenerItem: Identifiable {
    var id: UUID = UUID()
    var order: Int
    var itemType: String  // Par exemple "quote" ou "artwork"
    
    // Champs communs
    var details: String
    var author: String
    var authorBirthYear: Int
    var authorDeathYear: Int?
    var authorImageName: String
    var wikipediaURL: URL?
    
    // Champs spécifiques à la citation
    var text: String
    
    // Champs spécifiques à l'œuvre
    var imageName: String
    var title: String
    var year: String
    
    init(order: Int, itemType: String, details: String, author: String, authorBirthYear: Int, authorDeathYear: Int?, authorImageName: String, wikipediaURL: URL?, text: String, title: String, year: String, imageName: String) {
        self.order = order
        self.itemType = itemType
        self.author = author
        self.authorBirthYear = authorBirthYear
        self.authorDeathYear = authorDeathYear
        self.authorImageName = authorImageName
        self.wikipediaURL = wikipediaURL
        self.details = details
        self.text = text
        self.title = title
        self.year = year
        self.imageName = imageName
    }
}
