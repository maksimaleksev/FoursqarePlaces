//
//  ShopType.swift
//  FoursqarePlaces
//
//  Created by Maxim Alekseev on 26.11.2020.
//

import Foundation

enum VenueType: String {
    case food
    case coffee
    case shop
    case trending
}

extension VenueType {
    
    var ruString: String {
        
        switch self {
        case .food:
            return "Еда"
        case .coffee:
            return "Кофе"
        case .shop:
            return "Магазины"
        case .trending:
            return "Тренды"
        }
    }
    
    static func convertToVenueType(_ text: String) -> VenueType? {
        
        switch text {
        
        case "Еда":
            return .food
        case "Кофе":
            return .coffee
        case "Магазины":
            return .shop
        case "Тренды":
            return .trending
        default:
            print("Unknown VenueType")
            return nil
        }
    }
    
}


extension VenueType: CaseIterable { }
