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

            VStack(spacing: 0) {
                if let uiImage = UIImage(named: imageName) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
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

                VStack(spacing: 4) {
                    Text(artworkName)
                        .font(.title2)
                        .foregroundColor(.white)
                    Text(artworkDate)
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 30)

                Spacer()
            }
        }
        .overlay(
            HStack {
                Button(action: {
                    showFullScreenArtworkImage = false
                }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20))
                        .foregroundColor(.blue)
                        .padding()
                }
                Spacer()
            },
            alignment: .bottomLeading
        )
        .statusBar(hidden: true)
    }
}

#Preview {
    FullScreenArtworkImageView(imageName: "Nutshell",
                                artworkName: "Time in a Nutshell",
                                artworkDate: "1986",
                                showFullScreenArtworkImage: .constant(true))
}
