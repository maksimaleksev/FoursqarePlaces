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
    
    let venuesType: BehaviorRelay<[String]> = BehaviorRelay(value: VenueType.allCases.map{ $0.ruString})
    
    //Picker controller components
    var componentsNumber: Int { return 1 }
    
    //Picker controller selected item
    private var selectedItem: VenueType?
    var selectedRow: Int?
    
    
    //MARK:- Methods
    
    func setSelectedItem (_ item: VenueType) {
        self.selectedItem = item
    }
}
