//
//  MapView.swift
//  SwiftCar
//
//  Created by Saumil Shah on 12/15/19.
//  Copyright © 2019 Saumil Shah. All rights reserved.
//

import SwiftUI
import MapKit

extension MKPointAnnotation {
    static var example: MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.title = "London"
        annotation.subtitle = "Home to the 2012 Summer Olympics."
        annotation.coordinate = CLLocationCoordinate2D(latitude: 51.5, longitude: -0.13)
        return annotation
    }
}

struct MapView: UIViewRepresentable {
    
    func ConvertCustomAnntoMKPoint(_ customAnnPoints: [CustomAnnotationPoint]) -> [MKAnnotation] {
        
        return customAnnPoints.map( { $0.annotationPt })
        
    }
    
    let locationManager = CLLocationManager()
    
    @Binding var centerCoordinate: CLLocationCoordinate2D
    
    var annotations: [CustomAnnotationPoint]
    
    var mapType: MKMapType = .standard
    var isMovable: Bool = true
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        mapView.mapType = mapType
        
        mapView.isUserInteractionEnabled = isMovable
        
        return mapView
        
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let region = MKCoordinateRegion(center: self.centerCoordinate, span: span)
        view.setRegion(region, animated: true)
        
        if annotations.count != view.annotations.count {
            
            view.removeAnnotations(view.annotations)
            view.addAnnotations(ConvertCustomAnntoMKPoint(annotations))
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.centerCoordinate = mapView.centerCoordinate
        }
    }
}

let testCoordinate = CLLocationCoordinate2D(
    latitude: 34.011_286, longitude: -116.166_868)

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        
        MapView(centerCoordinate: .constant(testCoordinate), annotations: [])
            .previewDevice("iPhone XS")
        
    }
}


//struct MapView: UIViewRepresentable {
//
//    @Binding var coordinate: CLLocationCoordinate2D
//
//    func updateUIView(_ view: MKMapView, context: Context) {
//
//        let span = MKCoordinateSpan(latitudeDelta: 4.0, longitudeDelta: 0.0)
//        let region = MKCoordinateRegion(center: coordinate, span: span)
//
//        view.setRegion(region, animated: true)
//
//    }
//
//    func makeUIView(context: Context) -> MKMapView {
//        MKMapView(frame: .zero)
//    }
//}
//

