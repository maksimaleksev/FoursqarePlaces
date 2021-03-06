//
//  MapViewModel.swift
//  FoursqarePlaces
//
//  Created by Maxim Alekseev on 28.11.2020.
//

import Foundation
import CoreLocation
import MapKit
import RxSwift
import RxCocoa

internal class MapViewModel{
    
    //MARK: - Set needed services
    //Init location manager
    private let userLocationManager = UserLocationManager()
    private var disposeBag = DisposeBag()
    
    //MARK: - Constants
    //Region radius for map
    private let regionRadius: CLLocationDistance = 3000
    
    //Accuracy region need to determine when to request new venues
    private let accuracyRegionRadius: CLLocationDistance = 100
    
    //Annotation identifier
    let annotationIdentifier = "VenueAnnotation"
    
    //MARK: - Variables
    
    //Is Map view loaded?
    var isMapViewLoadMap = false
    
    //If is Initial setup
    private var isInitialSetup = true
    
    //Check if granted access to location service
    var isGranted = BehaviorRelay<Bool>(value: false)
    
    //Get new user location
    var userLocation: BehaviorRelay<CLLocation> = BehaviorRelay(value: CLLocation())
    
    //To get previous location
    private var previousLocation = CLLocation()
    
    //Venues array used for building annotations on map
    var venues = BehaviorRelay<[Venue]>(value: [])
    
    
    //MARK: - Initilizer
    init() {
        userLocationManager.isAccess.bind(to: isGranted).disposed(by: disposeBag)
        self.userLocationManager.currentLocation.bind(to: self.userLocation).disposed(by: self.disposeBag)
        
    }
    
    //MARK: - Methods
    
    //Setting previousLocation
    private func setPreviousLocation(_ location: CLLocation) {
        self.previousLocation = location
    }
    
    //Checking new user location is in accuracy region
    private func isUserMoved (_ newLocation: CLLocation) -> Bool {
        let coveredDistance = newLocation.distance(from: self.previousLocation)
        return self.accuracyRegionRadius <= coveredDistance
    }
    
    //Make MapView Region
    func makeMapViewRegion(for location: CLLocation) -> MKCoordinateRegion? {
        
        if isInitialSetup {
            isInitialSetup = false
            loadVenuesData(for: location)
            return MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        } else if isUserMoved(location) {
            setPreviousLocation(location)
            loadVenuesData(for: location)
            return MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        }
        
        return nil
    }
    
    
    //Load venues data in location
    private func loadVenuesData(for location: CLLocation) {
        isGranted.filter { $0 == true }.subscribe (onNext: {[unowned self] _ in
               
            AppSettings.shared.venueType.subscribe(onNext: {[unowned self] venueType in
                
                let apiBuilder = FoursquareAPIBuilder()
                apiBuilder.setLocation(longitude: location.coordinate.longitude, latitude: location.coordinate.latitude)
                apiBuilder.setVenue(type: venueType)
                
                guard let resource = apiBuilder.buildFoursquareAPI() else { return }
                
                
                NetworkDataFetcher.shared.fetchCategories(api: resource) {[unowned self] venueResponse in
                    
                    guard let venueResponse = venueResponse else { return }
                    let v = venueResponse.response.groups.compactMap { $0 }.flatMap { $0.items }.compactMap {$0.venue}
                    self.venues.accept(v)
                }
                
            }).disposed(by: self.disposeBag)
                

        }).disposed(by: disposeBag)
        
    }
}
