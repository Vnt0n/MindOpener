//
//  FirstView.swift
//  MindOpener
//
//  Created by Vnt0n on 06/03/2025.
//


import SwiftUI

struct FirstView: View {
    let showStartButton: Bool

    // Un initialiseur avec une valeur par défaut
    init(showStartButton: Bool = true) {
        self.showStartButton = showStartButton
    }
    
    let textContent = NSLocalizedString("Robert Filliou’s work emerges as a meditation on the boundless realm of possibilities, where art liberates itself from conventional constraints to merge with the vibrant experience of everyday life. Through elegantly pared-down gestures and unpredictable installations, he challenges the boundary between creation and existence, inviting everyone to recognize in the present moment a spark of genuine creativity. His approach, simultaneously playfully daring and marked by singular intellectual rigor, transforms chance and error into conduits of subversive inspiration. By dismantling traditional aesthetic conventions, Filliou reimagines art as an open dialogue, with life itself serving as the canvas for an authentic and inexhaustible expression.", comment: "FirstViewText")

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Text("Robert Filliou")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 15)
                
                Text("Joie sur vous")
                    .font(.title)
                    .padding(.bottom, 10)
                
                GeometryReader { geometry in
                    ScrollView {
                        VStack {
                            Text(textContent)
                                .font(.system(size: UIDevice.current.userInterfaceIdiom == .pad ? 21 : 17))
                                .multilineTextAlignment(.leading)
                                .lineSpacing(10)
                                .padding(.horizontal, 50)
                                .frame(width: geometry.size.width)
                            
                            Text("Sélection des œuvres, cartels :")
                                .padding(.top, 50)
                                .font(.system(size: 15))
                                .fontWeight(.semibold)
                            
                            Text("Antoine Chosson")
                                .font(.system(size: 15))
                                .padding(.bottom, 25)
                        }
                        .frame(minHeight: geometry.size.height)
                    }
                }
                
                Spacer()
                
                // Affiche le bouton seulement si showStartButton est true
                if showStartButton {
                    NavigationLink(destination: MainView()) {
                        Text("Commencer la visite")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: 300)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 40)
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
            .navigationBarHidden(true)
        }
    }
}

struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        FirstView()
    }
}
