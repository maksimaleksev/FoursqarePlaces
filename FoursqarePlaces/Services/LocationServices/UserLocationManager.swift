//
//  UserLocationManager.swift
//  FoursqarePlaces
//
//  Created by Maxim Alekseev on 25.11.2020.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa

internal final class UserLocationManager: NSObject {
    
    private var locationManager = CLLocationManager()
    
    //Check app access to location service
    var isAccess = BehaviorRelay<Bool>(value: false)
    
    //Getting current location
    var currentLocation: BehaviorRelay<CLLocation> = BehaviorRelay(value: CLLocation())
    
    private var isEnabled: Bool { return CLLocationManager.isEnabled }
    private var canRequestAccess: Bool { return CLLocationManager.canRequestService}
    
   override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}


//MARK: - CLLocationManagerDelegate
extension UserLocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        isAccess.accept(isEnabled)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else { return }
        currentLocation.accept(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
        print("Error while determinating position \(error)")
    }
}
