//
//  ShareCardView.swift
//  MindOpener
//
//  Created by Vnt0n on 06/03/2025.
//


import SwiftUI

struct ShareCardView: View {
    let item: MindOpenerItem
    
    var body: some View {
        VStack(spacing: 16) {
            if item.itemType == "quote" {
                // Pour la citation : texte puis informations de l'auteur
                Text(item.text)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                HStack(spacing: 26) {
                    Image(item.authorImageName)
                        .resizable()
                        .frame(width: 75, height: 75)
                        .clipShape(RoundedRectangle(cornerRadius: 10))

                    VStack(alignment: .center, spacing: 4) {
                        Text(item.author)
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        Text("\(item.authorBirthYear) - \(item.authorDeathYear.map { String($0) } ?? "present")")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            } else if item.itemType == "artwork" {
                // Pour l'œuvre : image entière, titre + date, puis auteur
                Image(item.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Text("\(item.title) - \(item.year)")
                    .font(.title2)
                    .padding(.top, 8)
                    .padding(.bottom, 20)
                
                HStack(spacing: 26) {
                    Image(item.authorImageName)
                        .resizable()
                        .frame(width: 75, height: 75)
                        .clipShape(RoundedRectangle(cornerRadius: 10))

                    VStack(alignment: .center, spacing: 4) {
                        Text(item.author)
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        Text("\(item.authorBirthYear) - \(item.authorDeathYear.map { String($0) } ?? "present")")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.bottom, 20)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
//        .cornerRadius(12)
//        .shadow(radius: 5)
    }
}

struct ShareCardView_Previews: PreviewProvider {
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
            ShareCardView(item: sampleQuoteItem)
                .previewDisplayName("Card Citation")
                .previewLayout(.sizeThatFits)
            
            ShareCardView(item: sampleArtworkItem)
                .previewDisplayName("Card Artwork")
                .previewLayout(.sizeThatFits)
        }
    }
}