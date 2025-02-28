//
//  Artwork.swift
//  MindOpener
//
//  Created by Vnt0n on 27/02/2025.
//

import SwiftData

@Model
class Artwork {
    var artworkImageName: String?
    var authorName: String
    var authorBirthYear: Int
    var authorDeathYear: Int
    var authorImage: String
    var wikiURLFr: String
    var wikiURLEn: String

    init(
        artworkImageName: String? = nil,
        authorName: String,
        authorBirthYear: Int,
        authorDeathYear: Int,
        authorImage: String,
        wikiURLFr: String,
        wikiURLEn: String
    ) {
        self.artworkImageName = artworkImageName
        self.authorName = authorName
        self.authorBirthYear = authorBirthYear
        self.authorDeathYear = authorDeathYear
        self.authorImage = authorImage
        self.wikiURLFr = wikiURLFr
        self.wikiURLEn = wikiURLEn
    }
}
