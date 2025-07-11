import SwiftUI

@Observable
class QuoteManager {
    var currentQuote: Quote?
    var isLoading = false
    var error: Error?
    
    private let userDefaults = UserDefaults.standard
    private let lastQuoteIDKey = "lastShownQuoteID"
    
    func fetchNewQuote() {
        isLoading = true
        error = nil
        
        fetchUniqueQuote()
    }
    
    private func fetchUniqueQuote() {
        NetworkService.shared.fetchQuote { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                    switch result {
                        case .success(let quote):
                        let lastID = self.userDefaults.integer(forKey: self.lastQuoteIDKey)
                        
                        if quote.id == lastID {
                            self.fetchUniqueQuote()
                            return
                            }
                                    
                        self.currentQuote = quote
                        self.userDefaults.set(quote.id, forKey: self.lastQuoteIDKey)
                        self.isLoading = false
                                    
                        case .failure(let error):
                            self.error = error
                            self.isLoading = false
                }
            }
        }
    }
}
