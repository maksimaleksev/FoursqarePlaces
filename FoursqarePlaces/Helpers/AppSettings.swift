//
//  AppSettings.swift
//  FoursqarePlaces
//
//  Created by Maxim Alekseev on 30.11.2020.
//

import RxSwift
import RxCocoa

internal final class AppSettings {
    
    //Singletone
    static var shared = AppSettings()
    
    //Service variables and constants
    private let userDefaults = UserDefaults.standard
    
    //Keys for UserDefaults
    private enum SettingsKeys: String {
        case venueType
        case selectedRow
    }
    
    
    // Settings for app
    var venueType: BehaviorRelay<VenueType> = BehaviorRelay(value: .food)
    var selectedRowInVenuePickerView: Int  = 0
    private init() {}
    
    //Store data in user defaults
    func storeData() {
        let venueTypeKey = SettingsKeys.venueType.rawValue
        let selectedRowKey = SettingsKeys.selectedRow.rawValue
        
        userDefaults.set(self.venueType.value.ruString, forKey: venueTypeKey)
        userDefaults.set(self.selectedRowInVenuePickerView, forKey: selectedRowKey)
    }
    
    //Get data from user defaults
    func getSettingsDataFromStorage() {
        
        guard let venueTypeRuString = userDefaults.string(forKey: SettingsKeys.venueType.rawValue),
              let venueType = VenueType.convertToVenueType(venueTypeRuString)
        else { return }
        let selectedRowKey = SettingsKeys.selectedRow.rawValue
        self.selectedRowInVenuePickerView = userDefaults.integer(forKey: selectedRowKey)
        self.venueType.accept(venueType)
        
    }
}
