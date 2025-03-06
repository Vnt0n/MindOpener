//
//  ShareItem.swift
//  MindOpener
//
//  Created by Vnt0n on 06/03/2025.
//

import SwiftUI
import UIKit
import AVFoundation  // Nécessaire pour AVMakeRect

extension MainView {
    func shareCurrentItem() {
        guard let item = selectedItem else { return }
        
        var itemsToShare: [Any] = []
        var tempFileURL: URL? = nil
        
        // Créer la carte combinée
        if let cardImage = createCardImage(for: item) {
            // Convertir l'image en fichier JPG
            if let jpgData = cardImage.jpegData(compressionQuality: 0.85) {
                let temporaryDirectory = FileManager.default.temporaryDirectory
                
                // Nom de fichier basé sur le titre ou l'auteur
                let safeFileName = item.itemType == "quote"
                    ? "\(item.author.replacingOccurrences(of: " ", with: "-"))"
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
                    
                    // Ajouter un descriptif textuel selon le type d'élément
                    if item.itemType == "quote" {
                        let quoteText = "\"\(item.text)\" — \(item.author)"
                        itemsToShare.append(quoteText)
                    } else {
                        let artworkInfo = "\(item.title) (\(item.year)) — \(item.author)"
                        itemsToShare.append(artworkInfo)
                    }
                } catch {
                    // Fallback en cas d'erreur
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
        activityVC.completionWithItemsHandler = { (_, _, _, _) in
            if let fileURL = tempFileURL {
                try? FileManager.default.removeItem(at: fileURL)
            }
        }
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            activityVC.popoverPresentationController?.sourceView = rootViewController.view
            activityVC.popoverPresentationController?.sourceRect = CGRect(
                x: UIScreen.main.bounds.width / 2,
                y: UIScreen.main.bounds.height / 2,
                width: 0,
                height: 0
            )
            activityVC.popoverPresentationController?.permittedArrowDirections = []
            rootViewController.present(activityVC, animated: true)
        }
    }
    
    // Fonction pour créer l'image combinée (carte)
    private func createCardImage(for item: MindOpenerItem) -> UIImage? {
        let authorBandHeight: CGFloat = 200
        let cardWidth: CGFloat = 900
        var cardHeight: CGFloat = 0
        
        if item.itemType == "quote" {
            // Pour une citation, on utilise une hauteur de contenu fixe
            let contentHeight: CGFloat = 600
            cardHeight = contentHeight + authorBandHeight
        } else {
            // Pour un artwork, on calcule la hauteur totale en fonction des éléments affichés
            let baseContentHeight: CGFloat = 1200
            let artworkAreaHeight = baseContentHeight * 0.85
            let titleMargin: CGFloat = 5
            let titleHeight: CGFloat = 60
            let spaceBelowTitle: CGFloat = 10
            // La partie utilisée par l'image, le titre et son espace
            let newContentHeight = artworkAreaHeight + titleMargin + titleHeight + spaceBelowTitle
            // La carte se termine exactement à la fin de la bande auteur
            cardHeight = newContentHeight + authorBandHeight
        }
        
        // Démarrer le contexte de rendu avec la hauteur calculée
        UIGraphicsBeginImageContextWithOptions(CGSize(width: cardWidth, height: cardHeight), false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        // Dessiner l'arrière-plan
        UIColor.systemBackground.setFill()
        context.fill(CGRect(x: 0, y: 0, width: cardWidth, height: cardHeight))
        
        if item.itemType == "quote" {
            // --- CAS QUOTE ---
            let contentHeight: CGFloat = 600
            let quoteRect = CGRect(x: 40, y: 40, width: cardWidth - 80, height: contentHeight - 80)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let quoteAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 50, weight: .medium),
                .foregroundColor: UIColor.label,
                .paragraphStyle: paragraphStyle
            ]
            
            let quoteText = "\(item.text)"
            let textSize = (quoteText as NSString).boundingRect(
                with: CGSize(width: quoteRect.width, height: .greatestFiniteMagnitude),
                options: .usesLineFragmentOrigin,
                attributes: quoteAttributes,
                context: nil
            )
            let textY = (contentHeight - textSize.height) / 2
            let textRect = CGRect(x: quoteRect.origin.x, y: textY, width: quoteRect.width, height: textSize.height)
            (quoteText as NSString).draw(in: textRect, withAttributes: quoteAttributes)
            
            // Dessiner la bande auteur en bas
            let authorBandRect = CGRect(x: 0, y: contentHeight, width: cardWidth, height: authorBandHeight)
            context.setFillColor(UIColor.systemGray6.cgColor)
            context.fill(authorBandRect)
            
            let authorNameAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 40, weight: .semibold),
                .foregroundColor: UIColor.label
            ]
            let authorYearsAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 30, weight: .regular),
                .foregroundColor: UIColor.secondaryLabel
            ]
            
            let yearsText = "\(item.authorBirthYear) - \(item.authorDeathYear.map { String($0) } ?? "")"
            let authorNameSize = (item.author as NSString).size(withAttributes: authorNameAttributes)
            let authorYearsSize = (yearsText as NSString).size(withAttributes: authorYearsAttributes)
            let textBlockWidth = max(authorNameSize.width, authorYearsSize.width)
            
            let imageSize = CGSize(width: 150, height: 150)
            let gap: CGFloat = 30
            let groupWidth = imageSize.width + gap + textBlockWidth
            let groupStartX = (cardWidth - groupWidth) / 2
            
            let imageRect = CGRect(
                x: groupStartX,
                y: contentHeight + (authorBandHeight - imageSize.height) / 2,
                width: imageSize.width,
                height: imageSize.height
            )
            let squarePath = UIBezierPath(roundedRect: imageRect, cornerRadius: 20)
            context.addPath(squarePath.cgPath)
            context.clip()
            if let authorImage = UIImage(named: item.authorImageName) {
                authorImage.draw(in: imageRect)
            }
            context.resetClip()
            
            // On calcule la hauteur totale du bloc texte (60 pour le nom + 40 pour les dates)
            let textBlockHeight: CGFloat = 100
            // On centre verticalement ce bloc par rapport à l'image de l'auteur
            let textBlockStartY = imageRect.midY - textBlockHeight/2

            let textStartX = groupStartX + imageSize.width + gap
            let authorNameRect = CGRect(x: textStartX, y: textBlockStartY, width: textBlockWidth, height: 60)
            (item.author as NSString).draw(in: authorNameRect, withAttributes: authorNameAttributes)

            let yearsSize = (yearsText as NSString).size(withAttributes: authorYearsAttributes)
            let authorYearsRect = CGRect(
                x: textStartX + (textBlockWidth - yearsSize.width) / 2,
                y: textBlockStartY + 60,
                width: yearsSize.width,
                height: 40
            )
            (yearsText as NSString).draw(in: authorYearsRect, withAttributes: authorYearsAttributes)
            
        } else {
            // --- CAS ARTWORK ---
            let baseContentHeight: CGFloat = 1200
            let artworkAreaHeight = baseContentHeight * 0.85
            let horizontalMargin: CGFloat = 20
            let topMargin: CGFloat = 20
            let availableHeight = artworkAreaHeight - topMargin
            
            if let artworkImage = UIImage(named: item.imageName) {
                let imageAreaRect = CGRect(x: horizontalMargin, y: 0, width: cardWidth - 2 * horizontalMargin, height: availableHeight)
                let imageRect = AVMakeRect(aspectRatio: artworkImage.size, insideRect: imageAreaRect)
                let centeredImageRect = CGRect(
                    x: horizontalMargin + ((cardWidth - 2 * horizontalMargin) - imageRect.width) / 2,
                    y: topMargin + (availableHeight - imageRect.height) / 2,
                    width: imageRect.width,
                    height: imageRect.height
                )
                artworkImage.draw(in: centeredImageRect)
            }
            
            // Afficher le titre juste en dessous de la zone artwork
            let titleMargin: CGFloat = 10
            let titleHeight: CGFloat = 60
            let titleY = artworkAreaHeight + titleMargin
            let titleParagraphStyle = NSMutableParagraphStyle()
            titleParagraphStyle.alignment = .center
            
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 30),
                .foregroundColor: UIColor.label,
                .paragraphStyle: titleParagraphStyle
            ]
            let titleText = "\(item.title) (\(item.year))"
            let titleRect = CGRect(x: 40, y: titleY, width: cardWidth - 80, height: titleHeight)
            (titleText as NSString).draw(in: titleRect, withAttributes: titleAttributes)
            
            // Calculer la position de la bande auteur juste après le titre
            let spaceBelowTitle: CGFloat = 10
            let newContentHeight = titleY + titleHeight + spaceBelowTitle
            
            let authorBandRect = CGRect(x: 0, y: newContentHeight, width: cardWidth, height: authorBandHeight)
            context.setFillColor(UIColor.systemGray6.cgColor)
            context.fill(authorBandRect)
            
            let authorNameAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 40, weight: .semibold),
                .foregroundColor: UIColor.label
            ]
            let authorYearsAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 30, weight: .regular),
                .foregroundColor: UIColor.secondaryLabel
            ]
            let yearsText = "\(item.authorBirthYear) - \(item.authorDeathYear.map { String($0) } ?? "")"
            let authorNameSize = (item.author as NSString).size(withAttributes: authorNameAttributes)
            let authorYearsSize = (yearsText as NSString).size(withAttributes: authorYearsAttributes)
            let textBlockWidth = max(authorNameSize.width, authorYearsSize.width)
            
            let imageSize = CGSize(width: 150, height: 150)
            let gap: CGFloat = 30
            let groupWidth = imageSize.width + gap + textBlockWidth
            let groupStartX = (cardWidth - groupWidth) / 2
            
            let authorImageRect = CGRect(
                x: groupStartX,
                y: newContentHeight + (authorBandHeight - imageSize.height) / 2,
                width: imageSize.width,
                height: imageSize.height
            )
            let squarePath = UIBezierPath(roundedRect: authorImageRect, cornerRadius: 20)
            context.addPath(squarePath.cgPath)
            context.clip()
            if let authorImage = UIImage(named: item.authorImageName) {
                authorImage.draw(in: authorImageRect)
            }
            context.resetClip()
            
            // On calcule la hauteur totale du bloc texte (60 pour le nom + 40 pour les dates)
            let textBlockHeight: CGFloat = 100
            // On centre verticalement ce bloc par rapport au rectangle de l'image de l'auteur (authorImageRect)
            let textBlockStartY = authorImageRect.midY - textBlockHeight/2

            let textStartX = groupStartX + imageSize.width + gap
            let authorNameRect = CGRect(x: textStartX, y: textBlockStartY, width: textBlockWidth, height: 60)
            (item.author as NSString).draw(in: authorNameRect, withAttributes: authorNameAttributes)

            let yearsSize = (yearsText as NSString).size(withAttributes: authorYearsAttributes)
            let authorYearsRect = CGRect(
                x: textStartX + (textBlockWidth - yearsSize.width) / 2,
                y: textBlockStartY + 60,
                width: yearsSize.width,
                height: 40
            )
            (yearsText as NSString).draw(in: authorYearsRect, withAttributes: authorYearsAttributes)
        }
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage
    }
}
