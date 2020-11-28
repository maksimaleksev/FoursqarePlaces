//
//  AnnotationBuilder.swift
//  FoursqarePlaces
//
//  Created by Maxim Alekseev on 28.11.2020.
//

import Foundation
import MapKit

protocol AnnotationBuilderProtocol {
    func reset()
    func setAnnotationTitle(_ text: String)
    func setAnnotationCoordinate(latitude: Double, longitude: Double)
    func makeAnnotation() -> MKPointAnnotation?
}

internal final class AnnotationBuilder: AnnotationBuilderProtocol {
    
    //MARK: - Variables to set annotation data
    private var text: String? = nil
    private var coordinate: CLLocationCoordinate2D? = nil
    
    
    //MARK: - AnnotationBuilder methods
    
    func reset() {
        self.text = nil
        self.coordinate = nil
    }
    
    func setAnnotationTitle(_ text: String) {
        self.text = text
    }
    
    func setAnnotationCoordinate(latitude: Double, longitude: Double) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.coordinate = coordinate
    }
    
    func makeAnnotation() -> MKPointAnnotation? {
        guard let text = self.text, let coordinate = self.coordinate else { return nil}
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = text
        reset()
        return annotation
    }
    
}
