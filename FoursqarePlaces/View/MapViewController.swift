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
    
    private let disposedBag = DisposeBag()
    private var viewModel: MapViewModel = MapViewModel()
        
    //MARK: - IBOutlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapViewController()
    }
    
    //MARK: - VC Methods
    
    //Setup VC
    private func setupMapViewController() {
        mapView.showsUserLocation = true
        mapView.delegate = self
        setUserLocationOnMapView()
        setupAnnotations()
    }
    
    //Setup user location on the mapView
    private func setUserLocationOnMapView() {
        viewModel.isGranted.filter{ $0 == false }.subscribe(onNext: {[unowned self] _ in
            
            self.viewModel.userLocation.asDriver().drive { [unowned self] userLocation in
                guard let mapView = self.mapView, self.viewModel.isMapViewLoadMap else { return }
                
                if let region = viewModel.makeMapViewRegion(for: userLocation){
                    mapView.setCenter(userLocation.coordinate, animated: true)
                    mapView.setRegion(region, animated: true)
                }
                
            }.disposed(by: self.disposedBag)
        }).disposed(by: disposedBag)
    }
    
    
    //Setup annotations
    private func setupAnnotations() {
        
        viewModel.venues.asDriver().drive { [removeAppleMapOverlays] venues in
            
            removeAppleMapOverlays()
            
            venues.forEach {[unowned self] venue in
                
                let builder = AnnotationBuilder()
                builder.setAnnotationTitle(venue.name)
                builder.setAnnotationCoordinate(latitude: venue.location.lat, longitude: venue.location.lng)
                guard let annotation = builder.makeAnnotation() else { return }
                self.mapView.addAnnotation(annotation)
                
            }
            
        }.disposed(by: disposedBag)
        
    }
    
    //Removing old annotations
    private func removeAppleMapOverlays() {
        let overlays = self.mapView.overlays
        self.mapView.removeOverlays(overlays)
        let annotations = self.mapView.annotations.filter { $0 !== self.mapView.userLocation }
        self.mapView.removeAnnotations(annotations)
    }
}


//MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        viewModel.isMapViewLoadMap = true
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard annotation is MKPointAnnotation else { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: viewModel.annotationIdentifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: viewModel.annotationIdentifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
}
