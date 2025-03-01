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
            
            Link(destination: quote.wikipediaURL) {
                Text(quote.author)
                    .font(.headline)
                    .foregroundColor(.blue)
            }
            
            Text("\(quote.authorBirthYear) - \(quote.authorDeathYear.map { String($0) } ?? "")")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
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
