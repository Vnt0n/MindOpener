//
//  QuoteRepository.swift
//  MindOpener
//
//  Created by Vnt0n on 27/02/2025.
//

import SwiftUI
import SwiftData

class QuoteRepository: ObservableObject {
    let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func fetchAllQuotes() throws -> [Quote] {
        try context.fetch(FetchDescriptor<Quote>())
    }
    
    func getRandomQuote() -> Quote? {
        do {
            let quotes = try fetchAllQuotes()
            return quotes.randomElement()
        } catch {
            print("Error fetching quotes:", error)
            return nil
        }
    }
    
    // etc. (seedQuotes, fetchQuoteOfDay, etc.)
}

