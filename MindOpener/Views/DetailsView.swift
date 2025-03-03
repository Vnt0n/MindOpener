//
//  DetailsView.swift
//  MindOpener
//
//  Created by Vnt0n on 01/03/2025.
//

import SwiftUI

struct DetailsView: View {
    let item: MindOpenerItem
    
    var body: some View {
        VStack(spacing: 20) {

            // Affichage du contenu principal en fonction du type d'item.
            if item.itemType == "quote" {
                Text(item.text)
                    .font(.body)
                    .padding()
            } else if item.itemType == "artwork" {
                Text("\(item.title) - \(item.year)")
                    .font(.body)
                    .padding()
            }
            
            Text(item.details)
                .font(.body)
                .padding()
            
            VStack(alignment: .center, spacing: 4) {
                // Le nom de l'auteur est tappable et ouvre la page Wikipedia via le service.
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
                
                // Affichage des dates de l'auteur.
                Text("\(item.authorBirthYear) - \(item.authorDeathYear.map { String($0) } ?? "")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
    }
}
//
//struct DetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailsView(item: {
//            let item = MindOpenerItem(order: 0, itemType: "quote")
//            item.text = "Art is what makes life more interesting than Art"
//            item.details = "Detailed text"
//            item.author = "Robert Filliou"
//            item.authorBirthYear = 1926
//            item.authorDeathYear = 1987
//            item.authorImageName = "RobertFilliou"
//            item.wikipediaURL = URL(string: "https://en.wikipedia.org/wiki/Robert_Filliou")!
//            return item
//        }())
//    }
//}
