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
    var builder = FoursquareAPIBuilder()
    var dataFetcher = NetworkDataFetcher.shared
    
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
            
            userLocationManager.getLocation { [weak self] (location) in
                completion(location)
                
                guard let location = location else { return }
                
                self?.builder.setLocation(longitude: location.longitude, latitude: location.latitude)
                self?.builder.setVenue(type: .coffee)
                
                guard let api = self?.builder.buildFoursquareAPI() else { return }
                
                self?.dataFetcher.fetchCategories(api: api) { response in
                    
                    print(response)
                }
                
                
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

