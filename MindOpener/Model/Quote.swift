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
    var authorName: String
    var authorBirthYear: Int
    var authorDeathYear: Int
    var authorImage: String
    var wikiURLFr: String
    var wikiURLEn: String

    init(
        textFr: String? = nil,
        textEn: String? = nil,
        authorName: String,
        authorBirthYear: Int,
        authorDeathYear: Int,
        authorImage: String,
        wikiURLFr: String,
        wikiURLEn: String
    ) {
        self.textFr = textFr
        self.textEn = textEn
        self.authorName = authorName
        self.authorBirthYear = authorBirthYear
        self.authorDeathYear = authorDeathYear
        self.authorImage = authorImage
        self.wikiURLFr = wikiURLFr
        self.wikiURLEn = wikiURLEn
    }
}
