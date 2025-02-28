//
//  MainQuoteView.swift
//  MindOpener
//
//  Created by Vnt0n on 27/02/2025.
//

import SwiftUI
import SwiftData

struct MainQuoteView: View {
    // On récupère le context SwiftData si on veut faire des fetch/inserts
    @Environment(\.modelContext) private var modelContext
    
    // Par exemple, on cherche toutes les quotes
    // La propriété @Query est un gros avantage de SwiftData
    @Query var quotes: [Quote]
    
    // State pour afficher des sheets, etc.
    @State private var showInfo = false
    @State private var showSettings = false
    @State private var showFullScreenImage = false
    
    init() {
        // Ici, on peut filtrer ou trier si besoin, ex:
        // _quotes = Query(sort: \.author, order: .forward)
        _quotes = Query()
    }
    
    var body: some View {
        VStack {
            
            Spacer()
            
            if let quote = quotes.first {
                if let imageName = quote.imageName {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(12)
                        .frame(maxHeight: 500)
                } else {
                    Text(quote.textFr ?? "Aucune citation disponible")
                        .font(.system(size: 42, weight: .bold, design: .default))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .lineSpacing(10)
                        .padding(.bottom, 50)
                }
                
                Spacer()
                
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
                                showFullScreenImage = true
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
                        Text(quote.author)
                            .font(.system(size: 28))
                        
                        Text("\(quote.birthYear) - \(quote.deathYear)")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                }
                .fullScreenCover(isPresented: $showFullScreenImage) {
                    FullScreenImageView(imageName: quote.authorImage, showFullScreenImage: $showFullScreenImage)
                }
                
            } else {
                Text("Nothing today")
            }
            
            Spacer()
            
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
        .sheet(isPresented: $showInfo) {
            InfoView()
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .onAppear {
            if quotes.isEmpty || quotes.first?.textFr == nil && quotes.first?.imageName == nil {
                seedRandomQuote()
            }
        }
    }
    
    func openWikipedia() {
        guard let quote = quotes.first else { return }
        
        let preferredLanguage = Locale.preferredLanguages.first ?? "en"
        let languageCode = preferredLanguage.split(separator: "-").first.map(String.init) ?? "en"
        
        guard let encodedAuthor = quote.author.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else { return }
        
        let apiURLString = "https://\(languageCode).wikipedia.org/api/rest_v1/page/summary/\(encodedAuthor)"
        guard let apiURL = URL(string: apiURLString) else { return }
        
        // Effectue une requête pour vérifier si l'article existe
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
    
    func seedRandomQuote() {
        let filliouQuote = Quote(
            textFr: "L’art est ce qui rend la vie plus intéressante que l’art",
            textEn: "Art is what makes life more interesting than art",
            author: "Robert Filliou",
            birthYear: 1926,
            deathYear: 1987,
            authorImage: "RobertFilliou",
            wikiURLFr: "https://fr.wikipedia.org/wiki/Robert_Filliou",
            wikiURLEn: "https://en.wikipedia.org/wiki/Robert_Filliou"
        )
        
        let filliouImage = Quote(
            textFr: nil,
            textEn: nil,
            author: "Robert Filliou",
            birthYear: 1926,
            deathYear: 1987,
            authorImage: "RobertFilliou",
            wikiURLFr: "https://fr.wikipedia.org/wiki/Robert_Filliou",
            wikiURLEn: "https://en.wikipedia.org/wiki/Robert_Filliou",
            imageName: "Nutshell"
        )
        
        let randomSeed = Bool.random() ? filliouQuote : filliouImage
        modelContext.insert(randomSeed)
        
        do {
            try modelContext.save()
        } catch {
            print("Error seeding quotes: \(error)")
        }
    }
}

#Preview {
    MainQuoteView()
        .modelContainer(for: [Quote.self], inMemory: true)
}
