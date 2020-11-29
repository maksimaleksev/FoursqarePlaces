//
//  ViewController.swift
//  FoursqarePlaces
//
//  Created by Maxim Alekseev on 25.11.2020.
//

import UIKit
import MapKit
import RxSwift

class MapViewController: UIViewController {
    
    //MARK: - Services var
    
    private var isMapViewLoadMap = false
    private let disposedBag = DisposeBag()
    private var viewModel: MapViewModel = MapViewModel()
    private let annotationIdentifier = "VenueAnnotation"
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapViewController()
    }
    
    //MARK: - VC Methods
    
    //Setup VC
    func setupMapViewController() {
        mapView.showsUserLocation = true
        mapView.delegate = self
        setUserLocationOnMapView()
        setupAnnotations()
    }
    
    //Setup user location on the mapView
    func setUserLocationOnMapView() {
        viewModel.isGranted.filter{ $0 == false }.subscribe {[unowned self] isGranted in
            
            self.viewModel.userLocation.asDriver().drive { [unowned self] userLocation in
                guard let mapView = self.mapView, self.isMapViewLoadMap else { return }
                
                if let region = viewModel.makeMapViewRegion(for: userLocation){
                    mapView.setCenter(userLocation.coordinate, animated: true)
                    mapView.setRegion(region, animated: true)
                }
                
            }.disposed(by: self.disposedBag)
        }.disposed(by: disposedBag)

        
    }
    
    
    //Setup annotations
    func setupAnnotations() {
        
        let annotations = mapView.annotations.filter({ !($0 is MKUserLocation) })
        mapView.removeAnnotations(annotations)
        
        viewModel.venues.asDriver().drive { venues in
            
            venues.forEach {[unowned self] venue in
                
                let builder = AnnotationBuilder()
                builder.setAnnotationTitle(venue.name)
                builder.setAnnotationCoordinate(latitude: venue.location.lat, longitude: venue.location.lng)
                guard let annotation = builder.makeAnnotation() else { return }
                self.mapView.addAnnotation(annotation)
                
            }
            
        }.disposed(by: disposedBag)
        
    }
}


//MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        isMapViewLoadMap = true
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard annotation is MKPointAnnotation else { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
}
