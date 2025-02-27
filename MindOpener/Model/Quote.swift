//
//  Quote.swift
//  MindOpener
//
//  Created by Vnt0n on 27/02/2025.
//

import SwiftData

@Model
class Quote {
    var textFr: String?
    var textEn: String?
    var author: String
    var birthYear: Int
    var deathYear: Int
    var authorImage: String
    var wikiURLFr: String
    var wikiURLEn: String
    var imageName: String?

    init(
        textFr: String? = nil,
        textEn: String? = nil,
        author: String,
        birthYear: Int,
        deathYear: Int,
        authorImage: String,
        wikiURLFr: String,
        wikiURLEn: String,
        imageName: String? = nil
    ) {
        self.textFr = textFr
        self.textEn = textEn
        self.author = author
        self.birthYear = birthYear
        self.deathYear = deathYear
        self.authorImage = authorImage
        self.wikiURLFr = wikiURLFr
        self.wikiURLEn = wikiURLEn
        self.imageName = imageName
    }
}
