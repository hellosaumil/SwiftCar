//
//  Data.swift
//  assignment02_SwiftUI
//
//  Created by Saumil Shah on 9/30/19.
//  Copyright © 2019 Saumil Shah. All rights reserved.
//
// Abstract: Helpers for loading data.
//

import UIKit
import SwiftUI
import Foundation

let tempUser = UserCredentials(firstname: "Bruce", lastname: "Wayne",
                               email: "bruce@wayne.corp", password: "123456",
                               userTypeID: 0)

let tempCar: Vehicle = Vehicle(vid: "nan", vehicleName: "Dummy", imageName: "ford_van", price: 0.0)

//var TempVehicleToLots: [ String : String ] = [
//    "ford_focus" : "Lot 101",
//    "ford_van" : "Lot 104",
//    "honda_civic" : "Lot 103",
//    "honda_crv" : "Lot 103",
//    "jeep_wrangler" : "Lot 104"
//]
//
//var TempLotsToVehicles: [ String : [String] ] = [
//    "Lot 101" : ["ford_focus"],
//    "Lot 104" : ["ford_van"],
//    "Lot 103" : ["honda_civic"],
//    "Lot 103" : ["honda_crv"],
//    "Lot 104": ["jeep_wrangler"]
//]

let emptyLot = ParkingLot(title: "Lot ---", subtitle: "Invalid Lot Location", coordinates: Coordinates(latitude: 0.0, longitude: 0.0))


let usersLoginDataFileName:String = "userLoginData.json"
let userCredListData: [UserCredentials] = loadCustomDataObject(usersLoginDataFileName)

let vehiclesDataFileName:String = "vehicles.json"
let vehicleListData: [Vehicle] = loadCustomDataObject(vehiclesDataFileName)


let parkingLotsDataFileName:String = "parkingLots.json"
let parkingLotsData: [ParkingLot] = loadCustomDataObject(parkingLotsDataFileName)

let lotAssignmentsDataFileName:String = "lotAssignments.json"
let vehicleLotsAssignments: [String:String] = loadDictDataObject(lotAssignmentsDataFileName)

let parkingLotData = createParkingLotInfoDict(from: vehicleLotsAssignments)

let fleetDataFileName:String = "fleet.json"
let fleetData: [String:[String]] = loadDictDataOfObjects(fleetDataFileName)

let usedVehicleDataFileName:String = "vehicleInUse.json"
let usedVehicleData: [String: Vehicle]? = loadUsedVehicleObject(usedVehicleDataFileName)

let allTripsDataFileName:String = "allTrips.json"
let allTripsData: [String: [Trip]] = loadAllTripsObject(allTripsDataFileName)


// MARK: User Defined Functinos
func createParkingLotInfoDict(from vehicleParking: [String: String]) -> [String:[String]] {
    
    var ParkingLotInfo: [ String : [String] ] = [:]

    for (vehicleID, LotTitle) in vehicleParking {
   
        var currentVehicles: [String] = ParkingLotInfo[LotTitle, default: []]
        currentVehicles.insert(vehicleID, at: currentVehicles.count)
        
        ParkingLotInfo[LotTitle] = currentVehicles
    }
    
    return ParkingLotInfo
}



func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

func loadFromAppDirectory<T: Decodable>(_ filename: String, as type: T.Type = T.self) throws -> T {
    
    let fileURL = getDocumentsDirectory().appendingPathComponent(filename)
    
    let data: Data
    let loadedData: T
    
    do {
        
        let fileData = try String(contentsOf: fileURL, encoding: .utf8)
        print("Data Read From File : \(fileData)")
        
        do {
            
            data = try Data(contentsOf: fileURL)
            
            do {
                
                let decoder = JSONDecoder()
                loadedData = try decoder.decode(T.self, from: data)
                
            } catch {
                
                print("Load: Couldn't parse \(fileURL) as \(T.self).\n\(error)")
                throw DataLoadSaveError.coudlNotParse
                
            }
            
        } catch {
            
            print("Load: Couldn't load \(filename).\n\(error)")
            throw DataLoadSaveError.coudlNotLoadFromBundle
        }
        
    } catch {
        
        print("ReadError: \(error)")
        throw error
    }
    
    
    return loadedData
}

func saveAnother<T: Encodable>(_ filename: String, data: T, as type: T.Type = T.self) throws {
    
    let jsonData: Data
    let jsonString:String
    
    let fileURL = getDocumentsDirectory().appendingPathComponent(filename)
    
    do {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        jsonData = try encoder.encode(data)
        
        if let validJsonString = String(data: jsonData, encoding: .utf8) {
            print("Save: jsonString: \n\(validJsonString)")
            print("Attempting to Save at: \(fileURL)...")
            
            jsonString = validJsonString
            
            do {
                
                try jsonString.write(to: fileURL, atomically: false, encoding: .utf8)
                print("\tFile Saved at: \(fileURL)")
                
            } catch {
                
                print("Save: Couldn't save \(fileURL).\n\(error)")
                throw DataLoadSaveError.coudlNotSaveToBundle
            }
            
        } else {
            print("\tSave: Couldn't convert jsonData to jsonString :\n")
            throw DataLoadSaveError.coudlNotParse
        }
        
    } catch {
        print("Save: Couldn't parse \(fileURL) as \(T.self):\n\(error)")
        throw DataLoadSaveError.coudlNotParse
    }
    
}


enum DataLoadSaveError: Error{
    case fileNotFound, coudlNotLoadFromBundle, coudlNotSaveToBundle, coudlNotParse
}


func saveUserCredListData(from updatedUserCredList:[UserCredentials]) throws {

    do {
        try saveAnother(usersLoginDataFileName, data: updatedUserCredList)
        print("User Credentials Saved.\n")

    } catch {
        print("\tCan't Save User Credentials Data...\(error)\n")
        throw error
    }

}

func saveLotAssignment(from updatedLotAssignments:[String:String]) throws {

    do {
        try saveAnother(lotAssignmentsDataFileName, data: updatedLotAssignments)
        print("Lot Assignments Saved.\n")

    } catch {
        print("\tCan't Save Lot Assignments Data...\(error)\n")
        throw error
    }

}

func saveVehicles(from updatedVehicles:[Vehicle]) throws {

    do {
        try saveAnother(vehiclesDataFileName, data: updatedVehicles)
        print("Vehicles Saved.\n")

    } catch {
        print("\tCan't Save Vehicles Data...\(error)\n")
        throw error
    }

}

func saveFleet(from updatedFleet:[String: [String]]) throws {

    do {
        try saveAnother(fleetDataFileName, data: updatedFleet)
        print("Fleet Data Saved.\n")

    } catch {
        print("\tCan't Save Fleet Data...\(error)\n")
        throw error
    }

}

func saveUsedVehicle(from usedVehicle:[String:Vehicle]?) throws {

    guard let validUsedVehicle = usedVehicle else {
        return
    }
    
    do {
        try saveAnother(usedVehicleDataFileName, data: validUsedVehicle)
        print("Used Vehicle Saved.\n")

    } catch {
        print("\tCan't Save Used Vehicle Data...\(error)\n")
        throw error
    }

}

func saveAllTripsData(from allTrips:[String:[Trip]]) throws {
    
    do {
        try saveAnother(allTripsDataFileName, data: allTrips)
        print("All Trips Data Saved.\n")

    } catch {
        print("\tCan't Save All Trips Data...\(error)\n")
        throw error
    }

}


func loadCustomDataObject<T:Decodable>(_ filename: String, as type: T.Type = T.self) -> [T] {
    
    let loadSomeData: [T]
    
    do {
        loadSomeData = try loadFromBundle(filename)
        
    } catch {
        
        loadSomeData = [T]()
    }
    
    return loadSomeData
}


func loadUsedVehicleObject(_ filename: String) -> [String: Vehicle]? {
    
    let usedVehicleData: [String: Vehicle]?
    
    do {
        usedVehicleData = try loadFromBundle(filename)
        
    } catch {
        
        usedVehicleData = nil
    }
    
    return usedVehicleData
}

func loadAllTripsObject(_ filename: String) -> [String: [Trip]] {
    
    let allTripsData: [String: [Trip]]
    
    do {
        allTripsData = try loadFromBundle(filename)
        
    } catch {
        
        allTripsData = [:]
    }
    
    return allTripsData
}


func loadDictDataObject(_ filename: String) -> [String:String] {
    
    let loadSomeData: [String:String]
    
    do {
        loadSomeData = try loadFromBundle(filename)
        
    } catch {
        
//        loadSomeData = [String:String]()
        loadSomeData = ["ford_focus":"Lot 101"]
    }
    
    return loadSomeData
}

func loadDictDataOfObjects(_ filename: String) -> [String:[String]] {
    
    let loadSomeData: [String:[String]]
    
    do {
        loadSomeData = try loadFromBundle(filename)
        
    } catch {
        
//        loadSomeData = [String:[String]]()
        loadSomeData = ["ford_focus":["v1"]]
    }
    
    return loadSomeData
}




//
// Original Code of the load function has been modified.
//
// load function used from the following url:
// https://developer.apple.com/tutorials/swiftui/creating-and-combining-views
//
//
func loadFromBundle<T: Decodable>(_ filename: String, _ fileExtension:String? = nil, as type: T.Type = T.self) throws -> T {
    let data: Data
    let loadedData: T
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: fileExtension)
        else {
            print("Load: Couldn't find \(filename) in main bundle.")
            throw DataLoadSaveError.fileNotFound
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        print("Load: Couldn't load \(filename) from main bundle:\n\(error)")
        throw DataLoadSaveError.coudlNotLoadFromBundle
    }
    
    do {
        let decoder = JSONDecoder()
        loadedData = try decoder.decode(T.self, from: data)
    } catch {
        print("Load: Couldn't parse \(filename) as \(T.self):\n\(error)")
        throw DataLoadSaveError.coudlNotParse
    }
    
    return loadedData
}
