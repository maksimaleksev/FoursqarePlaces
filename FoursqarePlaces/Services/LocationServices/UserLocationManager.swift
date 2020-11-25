//
//  UserLocationManager.swift
//  FoursqarePlaces
//
//  Created by Maxim Alekseev on 25.11.2020.
//

import Foundation
import CoreLocation

internal final class UserLocationManager: NSObject {
          
    static let shared = UserLocationManager()
    
    private var locationManager = CLLocationManager()
    
    var isEnabled: Bool { return CLLocationManager.isEnabled }
    var canRequestAccess: Bool { return CLLocationManager.canRequestService}
    
       
    typealias AccessRequestBlock = (Bool) -> ()
    typealias LocationRequestBlock = (CLLocationCoordinate2D?) -> ()
    
    private var accessRequestCompletion: AccessRequestBlock?
    private var locationRequestCompletion: LocationRequestBlock?
    
        
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    func requestAccess(completion: AccessRequestBlock?) {
        accessRequestCompletion = completion
        locationManager.requestWhenInUseAuthorization()
    }
    
    func getLocation(completion: LocationRequestBlock?) {
        locationRequestCompletion = completion
        locationManager.startUpdatingLocation()
    }
}


//MARK: - CLLocationManagerDelegate
extension UserLocationManager: CLLocationManagerDelegate {
             
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            print(status)
            accessRequestCompletion?(isEnabled)
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = manager.location?.coordinate else { return }
            locationRequestCompletion?(location)
            locationRequestCompletion = nil
            //manager.stopUpdatingLocation()
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            manager.stopUpdatingLocation()
            locationRequestCompletion?(nil)
            locationRequestCompletion = nil
        }     
}
