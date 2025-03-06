//
//  ShareItem.swift
//  MindOpener
//
//  Created by Vnt0n on 06/03/2025.
//

import SwiftUI
import UIKit
import AVFoundation  // Add this import statement

// Extension pour MainView
extension MainView {
    func shareCurrentItem() {
        guard let item = selectedItem else { return }
        
        var itemsToShare: [Any] = []
        var tempFileURL: URL? = nil
        
        // Créer une carte combinée
        if let cardImage = createCardImage(for: item) {
            // Convertir l'image de la carte en fichier JPG
            if let jpgData = cardImage.jpegData(compressionQuality: 0.85) {
                let temporaryDirectory = FileManager.default.temporaryDirectory
                
                // Créer un nom de fichier basé sur le titre ou l'auteur
                let safeFileName = item.itemType == "quote"
                    ? "quote-\(item.author.replacingOccurrences(of: " ", with: "-"))"
                    : item.title.replacingOccurrences(of: " ", with: "-")
                
                // Nettoyer le nom de fichier
                let cleanFileName = safeFileName
                    .replacingOccurrences(of: "/", with: "-")
                    .replacingOccurrences(of: "\\", with: "-")
                    .replacingOccurrences(of: ":", with: "-")
                    .replacingOccurrences(of: "*", with: "")
                    .replacingOccurrences(of: "?", with: "")
                    .replacingOccurrences(of: "\"", with: "")
                    .replacingOccurrences(of: "<", with: "")
                    .replacingOccurrences(of: ">", with: "")
                    .replacingOccurrences(of: "|", with: "-")
                
                let fileName = "\(cleanFileName).jpg"
                let fileURL = temporaryDirectory.appendingPathComponent(fileName)
                
                do {
                    try jpgData.write(to: fileURL)
                    tempFileURL = fileURL
                    itemsToShare.append(fileURL)
                    
                    // Ajouter un texte descriptif selon le type d'élément
                    if item.itemType == "quote" {
                        let quoteText = "\"\(item.text)\" — \(item.author)"
                        itemsToShare.append(quoteText)
                    } else {
                        let artworkInfo = "\(item.title) (\(item.year)) — \(item.author)"
                        itemsToShare.append(artworkInfo)
                    }
                } catch {
                    // Fallback au partage de texte uniquement en cas d'erreur
                    if item.itemType == "quote" {
                        itemsToShare.append("\"\(item.text)\" — \(item.author)")
                    } else if let originalImage = UIImage(named: item.imageName) {
                        itemsToShare.append(originalImage)
                        itemsToShare.append("\(item.title) (\(item.year)) — \(item.author)")
                    }
                }
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
    
    // Fonction pour créer l'image combinée (carte)
    private func createCardImage(for item: MindOpenerItem) -> UIImage? {
        // Définir la taille de la carte
        let cardWidth: CGFloat = 1080 // bonne résolution pour les médias sociaux
        let contentHeight: CGFloat = item.itemType == "quote" ? 800 : 1200 // plus grand pour les œuvres d'art
        let authorBandHeight: CGFloat = 200
        let cardHeight = contentHeight + authorBandHeight
        
        // Commencer le contexte de rendu
        UIGraphicsBeginImageContextWithOptions(CGSize(width: cardWidth, height: cardHeight), false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        // Dessiner l'arrière-plan
        let backgroundColor = UIColor.systemBackground
        backgroundColor.setFill()
        context.fill(CGRect(x: 0, y: 0, width: cardWidth, height: cardHeight))
        
        // Selon le type d'élément, dessiner le contenu principal
        if item.itemType == "quote" {
            // Dessiner la citation
            let quoteRect = CGRect(x: 40, y: 40, width: cardWidth - 80, height: contentHeight - 80)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let quoteTextColor = UIColor.label
            let quoteAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 60, weight: .medium),
                .foregroundColor: quoteTextColor,
                .paragraphStyle: paragraphStyle
            ]
            
            // Calculer la taille du texte pour le centrer
            let quoteText = "\"\(item.text)\""
            let textSize = (quoteText as NSString).boundingRect(
                with: CGSize(width: quoteRect.width, height: .greatestFiniteMagnitude),
                options: .usesLineFragmentOrigin,
                attributes: quoteAttributes,
                context: nil
            )
            
            let textY = (contentHeight - textSize.height) / 2
            let textRect = CGRect(
                x: quoteRect.origin.x,
                y: textY,
                width: quoteRect.width,
                height: textSize.height
            )
            
            (quoteText as NSString).draw(in: textRect, withAttributes: quoteAttributes)
        } else {
            // Dessiner l'œuvre d'art
            if let artworkImage = UIImage(named: item.imageName) {
                // Calculer les dimensions pour conserver le ratio
                let imageRect = AVMakeRect(
                    aspectRatio: artworkImage.size,
                    insideRect: CGRect(x: 0, y: 0, width: cardWidth, height: contentHeight)
                )
                
                // Centrer l'image
                let centeredImageRect = CGRect(
                    x: (cardWidth - imageRect.width) / 2,
                    y: (contentHeight - imageRect.height) / 2,
                    width: imageRect.width,
                    height: imageRect.height
                )
                
                artworkImage.draw(in: centeredImageRect)
                
                // Dessiner le titre de l'œuvre en bas de l'image
                let titleParagraphStyle = NSMutableParagraphStyle()
                titleParagraphStyle.alignment = .center
                
                let titleAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 40, weight: .semibold),
                    .foregroundColor: UIColor.label,
                    .paragraphStyle: titleParagraphStyle
                ]
                
                let titleText = "\(item.title) (\(item.year))"
                let titleRect = CGRect(
                    x: 40,
                    y: contentHeight - 80,
                    width: cardWidth - 80,
                    height: 60
                )
                
                (titleText as NSString).draw(in: titleRect, withAttributes: titleAttributes)
            }
        }
        
        // Dessiner la bande d'auteur en bas
        let authorBandRect = CGRect(x: 0, y: contentHeight, width: cardWidth, height: authorBandHeight)
        context.setFillColor(UIColor.systemGray6.cgColor)
        context.fill(authorBandRect)
        
        // Dessiner la photo de l'auteur
        if let authorImage = UIImage(named: item.authorImageName) {
            let imageSize = CGSize(width: 150, height: 150)
            let imageRect = CGRect(
                x: 50,
                y: contentHeight + (authorBandHeight - imageSize.height) / 2,
                width: imageSize.width,
                height: imageSize.height
            )
            
            // Créer un chemin de masque circulaire
            let circlePath = UIBezierPath(
                roundedRect: imageRect,
                cornerRadius: imageSize.width / 2
            )
            context.addPath(circlePath.cgPath)
            context.clip()
            
            authorImage.draw(in: imageRect)
            context.resetClip()
        }
        
        // Dessiner le nom de l'auteur et les dates
        let authorTextX: CGFloat = 230
        let authorNameAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 50, weight: .bold),
            .foregroundColor: UIColor.label
        ]
        
        let authorYearsAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 36, weight: .regular),
            .foregroundColor: UIColor.secondaryLabel
        ]
        
        let authorNameRect = CGRect(
            x: authorTextX,
            y: contentHeight + 60,
            width: cardWidth - authorTextX - 40,
            height: 60
        )
        
        let authorYearsRect = CGRect(
            x: authorTextX,
            y: contentHeight + 120,
            width: cardWidth - authorTextX - 40,
            height: 40
        )
        
        (item.author as NSString).draw(in: authorNameRect, withAttributes: authorNameAttributes)
        
        let yearsText = "\(item.authorBirthYear) - \(item.authorDeathYear.map { String($0) } ?? "")"
        (yearsText as NSString).draw(in: authorYearsRect, withAttributes: authorYearsAttributes)
        
        // Finaliser l'image
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resultImage
    }
}
