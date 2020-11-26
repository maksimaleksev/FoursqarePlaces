//
//  RequestResponse.swift
//  FoursqarePlaces
//
//  Created by Maxim Alekseev on 26.11.2020.
//

import Foundation

struct VenueResponse: Decodable {
    
    var response: ResponseGroups
}

struct ResponseGroups: Decodable {
    
    var groups: [GroupItem]
}

struct GroupItem: Decodable {
    
    var items: [FeedItem]
}

struct FeedItem: Decodable {
    
    var venue: Venue
}

struct Venue:Decodable {
    
    var name: String
    var location: VenueLocation
}

struct VenueLocation: Decodable {
    
    var lat: Double
    var lng: Double
}
