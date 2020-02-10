//
//  ParkingLot.swift
//  SwiftCar
//
//  Created by Saumil Shah on 12/16/19.
//  Copyright © 2019 Saumil Shah. All rights reserved.
//

import Foundation
import MapKit

struct ParkingLot: Codable, Hashable {
    
    var title: String
    var subtitle: String
    
    var coordinates: Coordinates
    
    func getLotAnnotationPt() -> CustomAnnotationPoint {
        return CustomAnnotationPoint(title: self.title, subtitle: self.subtitle, coordinate: self.locationCoordinate())
    }
    
    func locationCoordinate() -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude)
    }
    
    func encodeToJSON() -> Data? { return try? JSONEncoder().encode(self) }
    
}
