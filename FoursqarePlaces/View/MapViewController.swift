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
    
    //MARK: - Setup Center User Button
    
    let centerUserButton: UIButton = {
       let button = UIButton()
        button.clipsToBounds = true
        button.setImage(UIImage(named: "location"), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.006842956413, green: 0.4770780206, blue: 0.9985149503, alpha: 1)
        return button
    }()
    
    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapViewController()
    }
    
    override func viewDidLayoutSubviews() {
        setupButtonLayer()
    }
    
    //MARK: - VC Methods
    
    //Setup VC
    private func setupMapViewController() {
        mapView.showsUserLocation = true
        mapView.delegate = self
        setupButtonView()
        setUserLocationOnMapView()
        setupAnnotations()
    }
    
    //Setup centerUserButton
    private func setupButtonView() {
        centerUserButton.addTarget(self, action: #selector(centerUserButtonTapped), for: .touchUpInside)
        centerUserButton.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview(centerUserButton)
        
        NSLayoutConstraint.activate([
            centerUserButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -32),
            centerUserButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -32),
            centerUserButton.widthAnchor.constraint(equalToConstant: 50),
            centerUserButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func centerUserButtonTapped() {
        mapView.setCenter(viewModel.userLocation.value.coordinate, animated: true)
    }
    
    //Setup button layer
    func setupButtonLayer() {
        centerUserButton.layer.cornerRadius = centerUserButton.bounds.height/2
        
        //Setup button shadow
        centerUserButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        centerUserButton.layer.shadowOpacity = 1
        centerUserButton.layer.shadowRadius = 4
        centerUserButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        centerUserButton.layer.masksToBounds = false
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
                builder.setAnnotationTitle(venue.name.firstCapitalized)
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
