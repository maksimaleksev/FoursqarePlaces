//
//  SettingsViewModel.swift
//  FoursqarePlaces
//
//  Created by Maxim Alekseev on 29.11.2020.
//

import Foundation
import RxSwift
import RxCocoa

internal final class SettingsViewModel {
    
    //MARK: - Constants and variables
    //Data for venuePickerView
    let venuesType: BehaviorRelay<[String]> = BehaviorRelay(value: VenueType.allCases.map{ $0.ruString})
    
    //venuePickerView number of components
    var componentsNumber: Int { return 1 }
    
    //To get and set row in venuePickerView
    var selectedRow: Int
    
    //MARK: - Init
    init() {
        self.selectedRow = AppSettings.shared.selectedRowInVenuePickerView
    }
    
    //MARK: - Methods
    
    //Set settings for app
    func set(row: Int, and venueType: VenueType) {
        AppSettings.shared.venueType.accept(venueType)
        AppSettings.shared.selectedRowInVenuePickerView = row
    }
}
