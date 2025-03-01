//
//  Quote.swift
//  MindOpener
//
//  Created by Vnt0n on 01/03/2025.
//

import Foundation

struct Quote: Identifiable {
    let id = UUID()
    let text: String
    let author: String
    let birthYear: Int
    let deathYear: Int?
    let authorImageName: String
    let wikipediaURL: URL?
}
