//
//  CustomAnnotationPoint.swift
//  SwiftCar
//
//  Created by Saumil Shah on 12/15/19.
//  Copyright © 2019 Saumil Shah. All rights reserved.
//

import Foundation
import MapKit

struct Coordinates: Hashable, Codable {
    var latitude: Double
    var longitude: Double
}

struct CustomAnnotationPoint: Hashable {
    
    let id = UUID()
    let title: String
    let subtitle: String
    let coordinates: CLLocationCoordinate2D
    
    init(title: String, subtitle: String, lat: CLLocationDegrees, long: CLLocationDegrees) {
        
        self.title = title
        self.subtitle = subtitle
        
        self.coordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        
        self.init(title: title, subtitle: subtitle,
                  lat: coordinate.latitude, long: coordinate.longitude)
    }
    
    var annotationPt: MKPointAnnotation {
        
        let newAnnoPoint = MKPointAnnotation()
        
        newAnnoPoint.title = self.title
        newAnnoPoint.subtitle = self.subtitle
        newAnnoPoint.coordinate = self.coordinates
        
        return newAnnoPoint
        
    }
    
    // MARK: Hashable
    static func == (lhs: CustomAnnotationPoint, rhs: CustomAnnotationPoint) -> Bool {
        return (lhs.coordinates.latitude == rhs.coordinates.latitude) ||
            (lhs.coordinates.longitude == rhs.coordinates.longitude)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
