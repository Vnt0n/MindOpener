//
//  WikipediaService.swift
//  MindOpener
//
//  Created by Vnt0n on 06/03/2025.
//


import Foundation
import UIKit

struct WikipediaService {
    static func openWikipedia(for author: String) async {
        let preferredLanguage = Locale.preferredLanguages.first ?? "en"
        let languageCode = preferredLanguage.split(separator: "-").first.map(String.init) ?? "en"
        
        guard let encodedAuthor = author.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else { return }
        
        let apiURLString = "https://\(languageCode).wikipedia.org/api/rest_v1/page/summary/\(encodedAuthor)"
        guard let apiURL = URL(string: apiURLString) else { return }
        
        do {
            let (_, response) = try await URLSession.shared.data(from: apiURL)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                let fullURLString = "https://\(languageCode).wikipedia.org/wiki/\(encodedAuthor)"
                if let url = URL(string: fullURLString) {
                    await MainActor.run {
                        UIApplication.shared.open(url)
                    }
                }
            } else {
                let fallbackURLString = "https://en.wikipedia.org/wiki/\(encodedAuthor)"
                if let fallbackURL = URL(string: fallbackURLString) {
                    await MainActor.run {
                        UIApplication.shared.open(fallbackURL)
                    }
                }
            }
        } catch {
            let fallbackURLString = "https://en.wikipedia.org/wiki/\(encodedAuthor)"
            if let fallbackURL = URL(string: fallbackURLString) {
                await MainActor.run {
                    UIApplication.shared.open(fallbackURL)
                }
            }
        }
    }
}