//
//  InfoView.swift
//  MindOpener
//
//  Created by Vnt0n on 27/02/2025.
//

import SwiftUI

struct InfoView: View {
    var body: some View {
        VStack {
            Text("Informations sur l'application")
                .font(.title)
        }
        .statusBar(hidden: true) // ← Cacher aussi dans la sheet
    }
}

#Preview {
    InfoView()
}
