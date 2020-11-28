//
//  FourSquareAPIBuilder.swift
//  FoursqarePlaces
//
//  Created by Maxim Alekseev on 26.11.2020.
//

import Foundation
import CoreLocation

protocol FoursquareAPIBuilderProtocol {
    func setLocation(longitude: Double, latitude: Double)
    func setVenue(type: VenueType)
    func buildFoursquareAPI() -> FoursquareAPI?
}

internal class FoursquareAPIBuilder: FoursquareAPIBuilderProtocol {
    
    //MARK: - Constants for API
    
    private let clientID = "JLMXOP3VWT5E3WKUWG1MRD1OLTX0VNX1J5SLV205U3GAFVSS"
    private let clientSecret = "RDVGOPEJDXGMPZUESRFU3JT0IIY5NGX4CBFT0X1W3J4TNNCW"
    private let v = "20201030"
    private let locale = "ru"
    
    //MARK: - Variables for API
    
    private var location = CLLocationCoordinate2D()
    private var type: VenueType? = nil
    private var urlComponents = URLComponents()

    
    //MARK: - Methods
    
    //Reset builder
    private func reset() {
        self.location = CLLocationCoordinate2D()
        self.type = nil
        self.urlComponents = URLComponents()
    }
    
    //Set user location
    func setLocation(longitude: Double, latitude: Double) {
        self.location.longitude = longitude
        self.location.latitude = latitude
    }
    
    //Set VenueType
    func setVenue(type: VenueType) {
        self.type = type
    }
    
    //Build build request for API Foursquare
    func buildFoursquareAPI() -> FoursquareAPI? {
        guard let type = type else {
            print("Can't build URL cause ShopType doesn't set")
            return nil
        }
        
        let llItem = URLQueryItem(name: "ll", value: "\(location.latitude),\(location.longitude)")
        let sectionItem = URLQueryItem(name: "section", value: type.rawValue)
        let clientIDItem = URLQueryItem(name: "client_id", value: clientID)
        let clientSecretItem = URLQueryItem(name: "client_secret", value: clientSecret)
        let vItem = URLQueryItem(name: "v", value: v)
        
        urlComponents.scheme = "https"
        urlComponents.host = "api.foursquare.com"
        urlComponents.path = "/v2/venues/explore"
        urlComponents.queryItems = [llItem, sectionItem, clientIDItem, clientSecretItem, vItem]
                
        guard let resultURL = urlComponents.url else {
            print("Can't build URL")
            return nil
        }
        reset()
        return FoursquareAPI(headers: ["Accept-Language": locale], url: resultURL)
    }
}
