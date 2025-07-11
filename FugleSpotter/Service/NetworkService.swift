import SwiftUI

class NetworkService {
    static let shared = NetworkService()
    private init() {}
    
    func fetchQuote(completion: @escaping (Result<Quote, Error>) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/quotes/random") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: -1)))
                return
            }
            
            do {
                let quote = try JSONDecoder().decode(Quote.self, from: data)
                completion(.success(quote))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
