//
//  CLLocationManager+Extension.swift
//  FoursqarePlaces
//
//  Created by Maxim Alekseev on 25.11.2020.
//

import Foundation
import CoreLocation

extension CLLocationManager {
    static var canRequestService: Bool {
        return authorizationStatus() != .restricted && authorizationStatus() != .denied
    }
    
    static var isEnabled: Bool {
        return authorizationStatus() == .authorizedAlways || authorizationStatus() == .authorizedWhenInUse
    }
}

