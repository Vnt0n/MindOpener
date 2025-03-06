//
//  FirstView.swift
//  MindOpener
//
//  Created by Vnt0n on 06/03/2025.
//


import SwiftUI

import SwiftUI

struct JustifiedText: UIViewRepresentable {
    let text: String
    let fontSize: CGFloat
    
    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .justified
        label.lineBreakMode = .byWordWrapping
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }
    
    func updateUIView(_ uiView: UILabel, context: Context) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let attributedString = NSAttributedString(
            string: text,
            attributes: [
                .font: UIFont.systemFont(ofSize: fontSize),
                .paragraphStyle: paragraphStyle
            ]
        )
        
        uiView.attributedText = attributedString
    }
}

struct FirstView: View {
    var body: some View {
        NavigationStack {
            VStack {
                
                Spacer()
                
                Text("Robert Filliou : \n Joie sur vous")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 40)

                JustifiedText(
                    text: "Robert Filliou, pionnier de l’art conceptuel et figure emblématique du mouvement Fluxus, défie les conventions en mêlant humour, poésie et spontanéité. Son œuvre invite à repenser la frontière entre art et vie, offrant au spectateur une expérience ludique et libératrice où l’imagination s’exprime sans contraintes.",
                    fontSize: 21
                )
                    .padding(.horizontal, 50)
                
                Spacer()
                
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
