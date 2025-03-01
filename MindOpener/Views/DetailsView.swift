//
//  DetailsView.swift
//  MindOpener
//
//  Created by Vnt0n on 01/03/2025.
//

import SwiftUI

struct DetailsView: View {
    let quote: Quote
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Details")
                .font(.title)
                .padding(.top)
            
            Text(quote.text)
                .font(.body)
                .padding()
            
            Text(quote.details)
                .font(.body)
                .padding()
            
            VStack(alignment: .leading, spacing: 4) {
                // Le nom de l'auteur est tappable et ouvre la page Wikipedia via le service.
                Button(action: {
                    Task {
                        await WikipediaService.openWikipedia(for: quote.author)
                    }
                }) {
                    Text(quote.author)
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                // Affichage des dates.
                Text("\(quote.authorBirthYear) - \(quote.authorDeathYear.map { String($0) } ?? "")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(quote: Quote(
            text: "Art is what makes life more interesting than Art",
            details: "Detailed text",
            author: "Robert Filliou",
            authorBirthYear: 1926,
            authorDeathYear: 1987,
            authorImageName: "RobertFilliou",
            wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/Robert_Filliou")!
        ))
    }
}
