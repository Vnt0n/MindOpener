//
//  MainQuoteView.swift
//  MindOpener
//
//  Created by Vnt0n on 27/02/2025.
//

import SwiftUI
import SwiftData

enum DisplayMode {
    case auto   // Affiche la Quote si présente, sinon l'Artwork
    case quote  // Force l'affichage de la Quote
    case artwork // Force l'affichage de l'Artwork
}

struct MainQuoteView: View {
    var displayMode: DisplayMode = .auto
    // Accès au contexte SwiftData pour fetch/insert
    @Environment(\.modelContext) private var modelContext
    
    // Requêtes pour récupérer les citations et les œuvres
    @Query var quotes: [Quote]
    @Query var artworks: [Artwork]
    
    // États pour afficher des sheets et les écrans en plein écran
    @State private var showInfo = false
    @State private var showSettings = false
    @State private var showFullScreenAuthorImage = false
    @State private var showFullScreenArtworkImage = false
    
    init(displayMode: DisplayMode = .auto) {
        self.displayMode = displayMode
        _quotes = Query()
        _artworks = Query()
    }
    
    var body: some View {
        VStack {
            Spacer()

            // Sélection de l'affichage en fonction du mode
            switch displayMode {
            case .quote:
                if let quote = quotes.first {
                    quoteView(quote: quote)
                } else {
                    Text("Nothing today")
                }
            case .artwork:
                if let artwork = artworks.first {
                    artworkView(artwork: artwork)
                } else {
                    Text("Nothing today")
                }
            case .auto:
                if let quote = quotes.first {
                    quoteView(quote: quote)
                } else if let artwork = artworks.first {
                    artworkView(artwork: artwork)
                } else {
                    Text("Nothing today")
                }
            }
            
            Spacer()
            
            // Barre d'action en bas
            HStack {
                Button(action: { showInfo.toggle() }) {
                    Image(systemName: "info.circle")
                        .foregroundColor(.blue)
                        .font(.system(size: 24))
                }
                
                Spacer()
                
                Image("Wikipedia-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                
                Button(action: openWikipedia) {
                    HStack(spacing: 6) {
                        Text("Go to Wikipedia")
                    }
                }
                .foregroundColor(.blue)
                
                Spacer()
                
                Button(action: { showSettings.toggle() }) {
                    Image(systemName: "gear")
                        .foregroundColor(.blue)
                        .font(.system(size: 24))
                }
            }
            .padding(.horizontal)
            .padding(.top, 16)
            .padding(.bottom, 20)
        }
        .padding(.horizontal, 25)
        .sheet(isPresented: $showInfo) { InfoView() }
        .sheet(isPresented: $showSettings) { SettingsView() }
        .onAppear {
            if quotes.isEmpty && artworks.isEmpty {
                if Bool.random() {
                    seedRandomQuote()
                } else {
                    seedRandomArtwork()
                }
            }
        }
    }
    
    // Vue pour afficher une Quote
    private func quoteView(quote: Quote) -> some View {
        VStack {
            
            Spacer()
            // Affichage de la citation (texte)
            Text(quote.textFr ?? "Aucune citation disponible")
                .font(.system(size: 42, weight: .bold, design: .default))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .lineSpacing(10)
                .padding(.bottom, 50)
            
            Spacer()
            
            // Détails de l'auteur de la citation
            HStack {
                Spacer()
                
                if let uiImage = UIImage(named: quote.authorImage) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 75, height: 75)
                        .cornerRadius(8)
                        .padding(.trailing, 20)
                        .onTapGesture {
                            showFullScreenAuthorImage = true
                        }
                } else {
                    Image(systemName: "person.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 75, height: 75)
                        .foregroundColor(.gray)
                        .padding(.trailing, 20)
                }
                
                Spacer()
                
                VStack(alignment: .center) {
                    Text(quote.authorName)
                        .font(.system(size: 28))
                    Text("\(quote.authorBirthYear) - \(quote.authorDeathYear)")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .fullScreenCover(isPresented: $showFullScreenAuthorImage) {
                FullScreenImageView(imageName: quote.authorImage, showFullScreenImage: $showFullScreenAuthorImage)
            }
        }
    }
    
    // Vue pour afficher une Artwork
    private func artworkView(artwork: Artwork) -> some View {
        VStack {
            if let imageName = artwork.artworkImageName {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(12)
                    .frame(maxHeight: 500)
                    .onTapGesture {
                        showFullScreenArtworkImage = true
                    }
            }
            
            HStack {
                Text("\(artwork.artworkName) - \(artwork.artworkDate)")
            }
            
            Spacer()
            
            
            // Détails de l'auteur de la citation
            HStack {
                Spacer()
                
                if let uiImage = UIImage(named: artwork.authorImage) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 75, height: 75)
                        .cornerRadius(8)
                        .padding(.trailing, 20)
                        .onTapGesture {
                            showFullScreenAuthorImage = true
                        }
                } else {
                    Image(systemName: "person.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 75, height: 75)
                        .foregroundColor(.gray)
                        .padding(.trailing, 20)
                }
                
                Spacer()
                
                VStack(alignment: .center) {
                    Text(artwork.authorName)
                        .font(.system(size: 28))
                    Text("\(artwork.authorBirthYear) - \(artwork.authorDeathYear)")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .fullScreenCover(isPresented: $showFullScreenAuthorImage) {
                FullScreenImageView(imageName: artwork.authorImage, showFullScreenImage: $showFullScreenAuthorImage)
            }
            
        }
    }
    
    // Fonction d'ouverture vers Wikipedia en utilisant la propriété 'author'
    func openWikipedia() {
        if let quote = quotes.first {
            openWikipedia(for: quote.authorName)
        } else if let artwork = artworks.first {
            openWikipedia(for: artwork.authorName)
        }
    }
    
    private func openWikipedia(for author: String) {
        let preferredLanguage = Locale.preferredLanguages.first ?? "en"
        let languageCode = preferredLanguage.split(separator: "-").first.map(String.init) ?? "en"
        
        guard let encodedAuthor = author.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else { return }
        
        let apiURLString = "https://\(languageCode).wikipedia.org/api/rest_v1/page/summary/\(encodedAuthor)"
        guard let apiURL = URL(string: apiURLString) else { return }
        
        let task = URLSession.shared.dataTask(with: apiURL) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                let fullURLString = "https://\(languageCode).wikipedia.org/wiki/\(encodedAuthor)"
                if let url = URL(string: fullURLString) {
                    DispatchQueue.main.async {
                        UIApplication.shared.open(url)
                    }
                }
            } else {
                let fallbackURLString = "https://en.wikipedia.org/wiki/\(encodedAuthor)"
                if let fallbackURL = URL(string: fallbackURLString) {
                    DispatchQueue.main.async {
                        UIApplication.shared.open(fallbackURL)
                    }
                }
            }
        }
        task.resume()
    }
    
    // Seed pour une Quote
    func seedRandomQuote() {
        let filliouQuote = Quote(
            textFr: "L’art est ce qui rend la vie plus intéressante que l’art",
            textEn: "Art is what makes life more interesting than art",
            authorName: "Robert Filliou",
            authorBirthYear: 1926,
            authorDeathYear: 1987,
            authorImage: "RobertFilliou",
            wikiURLFr: "https://fr.wikipedia.org/wiki/Robert_Filliou",
            wikiURLEn: "https://en.wikipedia.org/wiki/Robert_Filliou"
        )
        modelContext.insert(filliouQuote)
        do {
            try modelContext.save()
        } catch {
            print("Error seeding quotes: \(error)")
        }
    }
    
    // Seed pour une Artwork
    func seedRandomArtwork() {
        let filliouArtwork = Artwork(
            artworkImageName: "Nutshell",
            artworkName: "Time in a Nutshell",
            artworkDate: 1987,
            authorName: "Robert Filliou",
            authorBirthYear: 1926,
            authorDeathYear: 1987,
            authorImage: "RobertFilliou",
            wikiURLFr: "https://fr.wikipedia.org/wiki/Robert_Filliou",
            wikiURLEn: "https://en.wikipedia.org/wiki/RobertFilliou"
        )
        modelContext.insert(filliouArtwork)
        do {
            try modelContext.save()
        } catch {
            print("Error seeding artworks: \(error)")
        }
    }
}

#Preview("Artwork Preview") {
    let container: ModelContainer = {
        let container = try! ModelContainer(for: Quote.self, Artwork.self)
        let artwork = Artwork(
            artworkImageName: "Nutshell",
            artworkName: "Time in a Nutshell",
            artworkDate: 1987,
            authorName: "Robert Filliou",
            authorBirthYear: 1926,
            authorDeathYear: 1987,
            authorImage: "RobertFilliou",
            wikiURLFr: "https://fr.wikipedia.org/wiki/Robert_Filliou",
            wikiURLEn: "https://en.wikipedia.org/wiki/Robert_Filliou"
        )
        container.mainContext.insert(artwork)
        try? container.mainContext.save()
        return container
    }()
    
    MainQuoteView(displayMode: .artwork)
        .modelContainer(container)
}

#Preview("Quote Preview") {
    let container: ModelContainer = {
        let container = try! ModelContainer(for: Quote.self, Artwork.self)
        let quote = Quote(
            textFr: "L’art est ce qui rend la vie plus intéressante que l’art",
            textEn: "Art is what makes life more interesting than art",
            authorName: "Robert Filliou",
            authorBirthYear: 1926,
            authorDeathYear: 1987,
            authorImage: "RobertFilliou",
            wikiURLFr: "https://fr.wikipedia.org/wiki/Robert_Filliou",
            wikiURLEn: "https://en.wikipedia.org/wiki/Robert_Filliou"
        )
        container.mainContext.insert(quote)
        try? container.mainContext.save()
        return container
    }()
    
    MainQuoteView(displayMode: .quote)
        .modelContainer(container)
}
