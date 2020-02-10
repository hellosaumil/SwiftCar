//
//  UserData.swift
//  assignment02_SwiftUI
//
//  Created by Saumil Shah on 9/30/19.
//  Copyright © 2019 Saumil Shah. All rights reserved.
//

import Combine
import Foundation

final class UserData: ObservableObject {
    
    let willChange = PassthroughSubject<Void, Never>()
    
    @Published var currentUser:UserCredentials = UserCredentials() {
        willSet {
            willChange.send()
        }
    }

    @Published var registerdUsers:[UserCredentials] = userCredListData {
        willSet {
            willChange.send()
        }
    }
    
    @Published var availableVehicles:[Vehicle] = vehicleListData {
        willSet {
            willChange.send()
        }
    }
    
    @Published var availableLots:[ParkingLot] = parkingLotsData {
        willSet {
            willChange.send()
        }
    }
    
    @Published var vehicleParkingInfo:[String:String] = vehicleLotsAssignments {
        willSet {
            willChange.send()
        }
    }
    
    @Published var parkingLotInfo:[String:[String]] = parkingLotData {
        willSet {
            willChange.send()
        }
    }
    
    @Published var currentFleet:[String:[String]] = fleetData {
        willSet {
            willChange.send()
        }
    }
    
    @Published var VehicleInUse: [String:Vehicle]? = usedVehicleData {
        willSet {
            willChange.send()
        }
    }
    
    @Published var allTrips: [String:[Trip]] = allTripsData {
        willSet {
            willChange.send()
        }
    }
    
}
