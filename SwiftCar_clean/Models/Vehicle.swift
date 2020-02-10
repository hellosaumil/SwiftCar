//
//  Vehicle.swift
//  SwiftCar
//
//  Created by Saumil Shah on 12/16/19.
//  Copyright © 2019 Saumil Shah. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct Vehicle: Codable, Equatable, Hashable {
    
    let vid: String
    let vehicleName: String
    let imageName: String
    let price: Double
    
    var vehicleImage: Image? {
        
        ImageStore.shared.getImage(name: imageName, scale: 1.0)
    }
    
    static func == (lhs: Vehicle, rhs: Vehicle) -> Bool {
        return (lhs.vid == rhs.vid)
    }

}

final class ImageStore {
    static var shared = ImageStore()
    
    func getImage(name: String, scale: CGFloat) -> Image? {
        
        guard
            let url = Bundle.main.url(forResource: name, withExtension: "png"),
            let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
            let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
            
            else {
                print("Couldn't load image \(name).png from main bundle.")
                
//                return Image(systemName: "photo.fill")
                return nil
            }
        
        return Image(image, scale: scale, label: Text(verbatim: name))
    }
    
}

