//
//  ShareItem.swift
//  MindOpener
//
//  Created by Vnt0n on 06/03/2025.
//


import SwiftUI
import UIKit

// Extension pour MainView
extension MainView {
    func shareCurrentItem() {
        guard let item = selectedItem else { return }
        
        var itemsToShare: [Any] = []
        var tempFileURL: URL? = nil
        
        if item.itemType == "quote" {
            // Partager une citation
            let quoteText = "\"\(item.text)\" — \(item.author)"
            itemsToShare.append(quoteText)
        } else if item.itemType == "artwork" {
            // Partager une œuvre d'art
            if let originalImage = UIImage(named: item.imageName) {
                // Créer un fichier temporaire avec l'extension .jpg
                if let jpgData = originalImage.jpegData(compressionQuality: 0.7) {
                    let temporaryDirectory = FileManager.default.temporaryDirectory
                    
                    // Créer un nom de fichier basé sur le titre de l'œuvre
                    // Remplacer les espaces par des tirets et supprimer les caractères spéciaux
                    let safeTitle = item.title
                        .replacingOccurrences(of: " ", with: "-")
                        .replacingOccurrences(of: "/", with: "-")
                        .replacingOccurrences(of: "\\", with: "-")
                        .replacingOccurrences(of: ":", with: "-")
                        .replacingOccurrences(of: "*", with: "")
                        .replacingOccurrences(of: "?", with: "")
                        .replacingOccurrences(of: "\"", with: "")
                        .replacingOccurrences(of: "<", with: "")
                        .replacingOccurrences(of: ">", with: "")
                        .replacingOccurrences(of: "|", with: "-")
                    
                    let fileName = "\(safeTitle).jpg"
                    let fileURL = temporaryDirectory.appendingPathComponent(fileName)
                    
                    do {
                        try jpgData.write(to: fileURL)
                        tempFileURL = fileURL
                        itemsToShare.append(fileURL)
                    } catch {
                        // Fallback sur l'image originale si l'écriture échoue
                        itemsToShare.append(originalImage)
                    }
                } else {
                    // Fallback sur l'image originale si la compression échoue
                    itemsToShare.append(originalImage)
                }
                
                // Ajouter aussi les informations sur l'œuvre
                let artworkInfo = "\(item.title) (\(item.year)) — \(item.author)"
                itemsToShare.append(artworkInfo)
            }
        }
        
        // Créer et présenter la feuille de partage
        let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        
        // Nettoyer le fichier temporaire après le partage
        activityVC.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            if let fileURL = tempFileURL {
                try? FileManager.default.removeItem(at: fileURL)
            }
        }
        
        // Pour iPad : configurer le popoverPresentationController
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            activityVC.popoverPresentationController?.sourceView = rootViewController.view
            activityVC.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            activityVC.popoverPresentationController?.permittedArrowDirections = []
            
            rootViewController.present(activityVC, animated: true)
        }
    }
}
