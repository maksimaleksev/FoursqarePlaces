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
        
        viewModel.userLocation.asDriver().drive { [unowned self] userLocation in
            guard let mapView = self.mapView, self.isMapViewLoadMap else { return }
            
            if let region = viewModel.makeMapViewRegion(for: userLocation){
                mapView.setCenter(userLocation.coordinate, animated: true)
                mapView.setRegion(region, animated: true)
            }
            
        }.disposed(by: disposedBag)
    }
    
    
    //Setup annotations
    func setupAnnotations() {
        viewModel.venues.asDriver().drive { print($0) }.disposed(by: disposedBag)
        
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        isMapViewLoadMap = true
    }
}
