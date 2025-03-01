//
//  AuthorImageFullscreenView.swift
//  MindOpener
//
//  Created by Vnt0n on 01/03/2025.
//

import SwiftUI

struct AuthorImageFullscreenView: View {
    let imageName: String
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
        }
    }
}

struct AuthorImageFullscreenView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorImageFullscreenView(imageName: "RobertFilliou")
    }
}
