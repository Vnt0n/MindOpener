//
//  SettingsView.swift
//  MindOpener
//
//  Created by Vnt0n on 01/03/2025.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("General")) {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                        .onAppear {
                            if UserDefaults.standard.object(forKey: "isDarkMode") == nil {
                                isDarkMode = (colorScheme == .dark)
                            }
                        }
                }
                Section(header: Text("Language")) {
                    Text("Preferred language: English")
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
