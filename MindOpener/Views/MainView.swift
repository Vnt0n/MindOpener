//
//  MainView.swift
//  MindOpener
//
//  Created by Vnt0n on 01/03/2025.
//

import SwiftUI

struct MainView: View {
    // Création d'une instance de Quote avec les données en dur.
    let quote = Quote(
        text: "Art is what makes life more interesting than Art",
        author: "Robert Filliou",
        birthYear: 1926,
        deathYear: 1987,
        authorImageName: "RobertFilliou",
        wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/Robert_Filliou")
    )
    
    // Variables d'état pour gérer l'affichage des sheets.
    @State private var showingDetails = false
    @State private var showingAuthorImageFullscreen = false
    @State private var showingSettings = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                
                // Affichage de la citation.
                Text(quote.text)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding()
                    .minimumScaleFactor(0.5)
                    // Taper sur la citation ouvre la sheet DetailsView.
                    .onTapGesture {
                        showingDetails = true
                    }
                
                // Affichage des informations de l'auteur.
                HStack(spacing: 16) {
                    Image(quote.authorImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        // Taper sur l'image de l'auteur ouvre la sheet AuthorImageFullscreenView.
                        .onTapGesture {
                            showingAuthorImageFullscreen = true
                        }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        // Le nom de l'auteur est tappable et ouvre la page Wikipedia.
                        Button(action: {
                            if let url = quote.wikipediaURL {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text(quote.author)
                                .font(.headline)
                                .foregroundColor(.blue)
                        }
                        // Affichage des dates.
                        Text("\(quote.birthYear) - \(quote.deathYear.map { String($0) } ?? "")")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                // Boutons en bas de l'écran : partage et réglages.
                HStack {
                    Button(action: {
                        // Action pour le partage (à implémenter)
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.title)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        showingSettings = true
                    }) {
                        Image(systemName: "gearshape")
                            .font(.title)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            // Affichage de la sheet pour les détails.
            .sheet(isPresented: $showingDetails) {
                DetailsView(quote: quote)
            }
            // Affichage de la sheet pour l'image de l'auteur en plein écran.
            .sheet(isPresented: $showingAuthorImageFullscreen) {
                AuthorImageFullscreenView(imageName: quote.authorImageName)
            }
            // Affichage de la sheet des réglages.
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
