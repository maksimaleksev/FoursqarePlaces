//
//  ViewController.swift
//  FoursqarePlaces
//
//  Created by Maxim Alekseev on 25.11.2020.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    private var userLocationManager = UserLocationManager.shared
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapViewController()
        
    }
    
    // Setup VC
        func setupMapViewController() {
            mapView.showsUserLocation = true
            centerMapOnUserLocation()
            
        }
    
    //Get User Location
    func getUserLocation(completion: @escaping (CLLocationCoordinate2D?) -> ()) {
               
        userLocationManager.requestAccess { [userLocationManager] isSuccess in
            
            guard isSuccess else {
                completion(nil)
                return
            }
            
            userLocationManager.getLocation { (location) in
                completion(location)
            }
        }
    }

    // Center Map on user location
    func centerMapOnUserLocation() {
        
        getUserLocation { [mapView] location in
            
            guard let location = location else { return }
            
            let regionRadius: CLLocationDistance = 1000
            
            let region = MKCoordinateRegion(center: location,
                                            latitudinalMeters: regionRadius,
                                            longitudinalMeters: regionRadius)
            
            mapView!.setRegion(region, animated: true)
            
        }
      
    }
   
}

