//
//  TripObject.swift
//  SwitCar
//
//  Created by Saumil Shah on 12/17/19.
//  Copyright © 2019 Saumil Shah. All rights reserved.
//

import Foundation


struct Trip: Codable, Hashable {
    
    let userEmail: String
    let startDate: String
    var endDate: String
    
    let vehicleID: String
    let vehicleCost: Double
    
    mutating func endTrip() {
        self.endDate = getCurrentDateAndTime()
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine( userEmail+vehicleID+startDate+endDate  )
    }
    
    func getTripCost() -> Double {
        
        if self.startDate == "" || self.endDate == "" {return -1}
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let start_date = formatter.date(from: startDate)!
        let end_date = formatter.date(from: endDate)!
        
        print("Date1: \(start_date)")
        print("Date2: \(end_date)")

        let tripDuration:[Int] = getHrMinDuration(from: start_date, to: end_date)

        let totalHrs = tripDuration[0]
        let totalMins = tripDuration[1]

        let tripCost: Double = (Double(totalHrs) + Double(totalMins) / 60) * self.vehicleCost

        return tripCost
    }

}

func getHrMinDuration(from date1: Date, to date2: Date) -> [Int] {
    
    let elapsedTime = date2.timeIntervalSince(date1)
    
    let hours = floor(elapsedTime / 60 / 60)
    let minutes = floor((elapsedTime - (hours * 60 * 60)) / 60)

    
    print("\(Int(hours)) hr and \(Int(minutes)) min")
    return [Int(hours), Int(minutes)]
    
}

func getCurrentDateAndTime() -> String {
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    let dateNow = Date()
    
    print("Current Time: \( formatter.string(from: dateNow) )")
    
    return formatter.string(from: dateNow)
}
