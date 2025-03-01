//
//  Artwork.swift
//  MindOpener
//
//  Created by Vnt0n on 01/03/2025.
//

import Foundation

struct Artwork: Identifiable {
    let id = UUID()
    let title: String
    let year: String?
    let imageName: String
    let description: String?
}
