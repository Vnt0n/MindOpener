//
//  MainView.swift
//  MindOpener
//
//  Created by Vnt0n on 06/03/2025.
//


import SwiftUI
import SwiftData

struct MainView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \MindOpenerItem.order) private var items: [MindOpenerItem]
    
    // Binding pour la sélection du TabView (on stocke l'id de l'item sélectionné)
    @State private var selectedItemID: UUID?
    
    // Variables d'état pour afficher les sheets
    @State private var showingDetails = false
    @State private var showingAuthorImageFullscreen = false
    @State private var showingSettings = false
    
    @State private var showingShareSheet = false
    
    // Calcul de l'item actuellement sélectionné
    var selectedItem: MindOpenerItem? {
        items.first { $0.id == selectedItemID }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Zone swipeable : occupe tout l'espace disponible
                TabView(selection: $selectedItemID) {
                    ForEach(items) { item in
                        ZStack {
                            if item.itemType == "quote" {
                                Text(item.text)
                                    .font(.title)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .minimumScaleFactor(0.5)
                            } else if item.itemType == "artwork" {
                                GeometryReader { geometry in
                                    Image(item.imageName)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: geometry.size.width,
                                               height: geometry.size.height)
                                        .clipped()
                                }
                            }
                        }
                        .tag(item.id)
                        .onTapGesture {
                            showingDetails = true
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // On cache l'indicateur natif
                .frame(maxHeight: .infinity)
                .onAppear {
                    if selectedItemID == nil, let firstItem = items.first {
                        selectedItemID = firstItem.id
                    }
                }
                
                // Zone fixe pour les informations de l'auteur, juste au-dessus de la bande d'icônes
                if let item = selectedItem {
                    
                    HStack(spacing: 26) {
                        
                    Image(item.authorImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 75, height: 75)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .onTapGesture {
                            showingAuthorImageFullscreen = true
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
                            .buttonStyle(.plain)
                            
                            Text("\(item.authorBirthYear) - \(item.authorDeathYear.map { String($0) } ?? "")")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                    }
                    .padding(.vertical, 38)
                }
                
                // Bande fixe en bas : icônes et indicateur personnalisé
                HStack {
                    // Bouton partage
                    Button(action: {
                        shareCurrentItem()
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.title2)
                    }
                    .foregroundColor(.blue)
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                    
                    // Indicateur personnalisé
                    HStack(spacing: 8) {
                        ForEach(items.indices, id: \.self) { index in
                            Circle()
                                .frame(width: 8, height: 8)
                                .foregroundColor(
                                    items[index].id == selectedItemID
                                        ? (colorScheme == .dark ? Color.white : Color.black)
                                        : (colorScheme == .dark ? Color(UIColor.systemGray) : Color.gray)
                                )
                        }
                    }
                    
                    Spacer()
                    
                    // Bouton réglages
                    Button(action: {
                        showingSettings = true
                    }) {
                        Image(systemName: "gearshape")
                            .font(.title2)
                    }
                    .foregroundColor(.blue)
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .statusBarHidden(true)
            // Sheets pour les détails, l'image en plein écran et les réglages
            .sheet(isPresented: $showingDetails) {
                if let item = selectedItem {
                    DetailsView(item: item)
                } else {
                    Text("No item selected")
                }
            }
            .sheet(isPresented: $showingAuthorImageFullscreen) {
                if let authorImageName = selectedItem?.authorImageName {
                    AuthorImageFullscreenView(imageName: authorImageName)
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previewContainer: ModelContainer = {
        do {
            let schema = Schema([MindOpenerItem.self])
            let container = try ModelContainer(for: schema, configurations: [ModelConfiguration(nil)])
            let context = container.mainContext
            
            // Création d'un FetchDescriptor pour vérifier si des items existent déjà
            let fetchDescriptor = FetchDescriptor<MindOpenerItem>(sortBy: [SortDescriptor(\.order)])
            let existingItems = try context.fetch(fetchDescriptor)
            
            if existingItems.isEmpty {
                // Insertion des données codées en dur depuis HardCodedData
                for item in HardCodedData.items {
                    context.insert(item)
                }
                try context.save()
            }
            
            return container
        } catch {
            fatalError("Erreur lors de la création du container preview : \(error)")
        }
    }()
    
    static var previews: some View {
        MainView()
            .modelContainer(previewContainer)
    }
}
