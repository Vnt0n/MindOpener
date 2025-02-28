//
//  FullScreenImageView.swift
//  MindOpener
//
//  Created by Vnt0n on 27/02/2025.
//

import SwiftUI

struct FullScreenImageView: View {
    let imageName: String
    @Binding var showFullScreenImage: Bool
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if let uiImage = UIImage(named: imageName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showFullScreenImage = false
                    }
            } else {
                Text("Image not found")
                    .foregroundColor(.white)
                    .onTapGesture {
                        showFullScreenImage = false
                    }
            }
            
            VStack {
                Spacer()
                HStack {
                    Button(action: {
                        showFullScreenImage = false
                    }) {
                        HStack {
                            Image(systemName: "arrow.left")
                        }
                        .font(.system(size: 20))
                        .foregroundColor(.blue)
                        .padding()
                    }
                    Spacer()
                }
            }
        }
        .statusBar(hidden: true)
    }
}

#Preview {
    FullScreenImageView(imageName: "RobertFilliou", showFullScreenImage: .constant(true))
}
