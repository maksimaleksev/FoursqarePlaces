//
//  NetworkService.swift
//  FoursqarePlaces
//
//  Created by Maxim Alekseev on 26.11.2020.
//

import Foundation

internal final class NetworkService {
    
    static let shared = NetworkService()
    
    func request(api: FoursquareAPI, completion: @escaping (Result<Data, Error>) -> Void) {
        
        var request = URLRequest(url: api.url)
        request.allHTTPHeaderFields = api.headers
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else { return }
                completion(.success(data))
            }
        }.resume()
   }
    
}
