//
//  NetworkDataFetcher.swift
//  FoursqarePlaces
//
//  Created by Maxim Alekseev on 26.11.2020.
//

import Foundation

internal final class NetworkDataFetcher {
    
    static let shared = NetworkDataFetcher()
    
    func fetchCategories(api: FoursquareAPI, response: @escaping (VenueResponse?) -> Void) {
        
        
        NetworkService.shared.request(api: api) { (result) in
            
            switch result {
            
            case .success(let data):
                
                do {
                    
                    let requestResponse = try JSONDecoder().decode(VenueResponse.self, from: data)
                    response(requestResponse)
                    
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    response(nil)
                }

                
            case .failure(let error):
                print("Error received requesting data: \(error.localizedDescription)")
                response(nil)
                 }
        }
        
    }
}
