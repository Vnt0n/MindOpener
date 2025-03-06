//
//  DetailsView.swift
//  MindOpener
//
//  Created by Vnt0n on 06/03/2025.
//


import SwiftUI

struct DetailsView: View {
    let item: MindOpenerItem
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if item.itemType == "quote" {
                    Text(item.text)
                        .font(.title2)
                        .padding()
                } else if item.itemType == "artwork" {
                    Text("\(item.title) - \(item.year)")
                        .font(.title3)
                        .padding()
                    
                    if UIDevice.current.userInterfaceIdiom != .pad {
                        Image(item.imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .clipped()
                            .ignoresSafeArea(edges: .horizontal)
                    }
                }
                
                VStack(alignment: .center, spacing: 4) {
                    Button(action: {
                        Task {
                            await WikipediaService.openWikipedia(for: item.author)
                        }
                    }) {
                        Text(item.author)
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Text("\(item.authorBirthYear) - \(item.authorDeathYear.map { String($0) } ?? "")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Text(item.details)
                    .font(.body)
                    .padding()
                
                Spacer()
                
            }
            .padding()
        }
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var sampleQuoteItem: MindOpenerItem = {
        MindOpenerItem(
            order: 0,
            itemType: "quote",
            details: "Détails de la citation",
            author: "Robert Filliou",
            authorBirthYear: 1926,
            authorDeathYear: 1987,
            authorImageName: "RobertFilliou",
            wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/Robert_Filliou"),
            text: "Art is what makes life more interesting than Art",
            title: "",
            year: "",
            imageName: ""
        )
    }()
    
    static var sampleArtworkItem: MindOpenerItem = {
        MindOpenerItem(
            order: 1,
            itemType: "artwork",
            details: "Détails de l'œuvre",
            author: "Robert Filliou",
            authorBirthYear: 1926,
            authorDeathYear: 1987,
            authorImageName: "RobertFilliou",
            wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/Robert_Filliou"),
            text: "",
            title: "Time in a Nutshell",
            year: "1987",
            imageName: "Nutshell"
        )
    }()
    
    static var previews: some View {
        Group {
            DetailsView(item: sampleQuoteItem)
                .previewDisplayName("Quote Details")
            
            DetailsView(item: sampleArtworkItem)
                .previewDisplayName("Artwork Details")
        }
    }
}
