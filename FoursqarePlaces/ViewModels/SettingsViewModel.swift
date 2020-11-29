//
//  SettingsViewModel.swift
//  FoursqarePlaces
//
//  Created by Maxim Alekseev on 29.11.2020.
//

import Foundation

class SettingsViewModel {
    
    //Picker controller items
//        let venuesType = ["Кофейни", "Рестораны", "Магазины", "Тренды"]
    
    let venuesType: [String] = VenueType.allCases.map { $0.ruString }
    
    //Picker controller components
    let componentsNumber = 1
    
    //Picker controller selected item
    var selectedItem: String?
    var selectedIndex: Int?
    
}
