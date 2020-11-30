//
//  AppSettings.swift
//  FoursqarePlaces
//
//  Created by Maxim Alekseev on 30.11.2020.
//

import RxSwift
import RxCocoa

internal final class AppSettings {
    
    static var shared = AppSettings()
    
    //Data Settings for app
    var venueType: BehaviorRelay<VenueType> = BehaviorRelay(value: .food)
    var selectedRowInVenuePickerView: Int = 0
    
    private init() {}
}
