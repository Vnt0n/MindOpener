//
//  SettingsView.swift
//  MindOpener
//
//  Created by Vnt0n on 01/03/2025.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("General")) {
                    Toggle("Dark Mode", isOn: .constant(false))
                    // Ajoutez d'autres réglages ici.
                }
                Section(header: Text("Language")) {
                    // Options pour la langue.
                    Text("Preferred language: English")
                }
            }
            .navigationTitle("Settings")
            .navigationBarItems(trailing: Button("Done") {
                dismiss()
            })
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
