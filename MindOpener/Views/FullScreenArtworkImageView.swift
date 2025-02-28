//
//  FullScreenArtworkImageView.swift
//  MindOpener
//
//  Created by Vnt0n on 28/02/2025.
//

import SwiftUI

struct FullScreenArtworkImageView: View {
    let imageName: String
    let artworkName: String
    let artworkDate: String
    @Binding var showFullScreenArtworkImage: Bool

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if let uiImage = UIImage(named: imageName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showFullScreenArtworkImage = false
                    }
            } else {
                Text("Image not found")
                    .foregroundColor(.white)
                    .onTapGesture {
                        showFullScreenArtworkImage = false
                    }
            }
            
            VStack {
                Spacer()
                
                // Affichage du nom de l'œuvre et de sa date
                VStack(spacing: 4) {
                    Text(artworkName)
                        .font(.title)
                        .foregroundColor(.white)
                    Text(artworkDate)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 20)
                
                // Bouton "Back" pour revenir en arrière
                HStack {
                    Button(action: {
                        showFullScreenArtworkImage = false
                    }) {
                        HStack {
                            Image(systemName: "arrow.left")
                            Text("Back")
                        }
                        .font(.system(size: 20))
                        .foregroundColor(.blue)
                        .padding()
                    }
                    Spacer()
                }
                .padding(.bottom, 30)
            }
        }
        .statusBar(hidden: true)
    }
}

#Preview {
    FullScreenArtworkImageView(imageName: "ArtworkExample", artworkName: "Mon œuvre", artworkDate: "1870", showFullScreenArtworkImage: .constant(true))
}
