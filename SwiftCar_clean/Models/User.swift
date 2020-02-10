//
//  UserCredentials.swift
//  SwiftCar
//
//  Created by Saumil Shah on 12/15/19.
//  Copyright © 2019 Saumil Shah. All rights reserved.
//

import Foundation

enum UserTypes: String {
    case ridesharer="Swift Rider 🏎", fleetowner="Fleet Owner 🏢"
}

var usertypes: [UserTypes] = [.ridesharer, .fleetowner]

let emptyTrips: [Trip] = [Trip(userEmail: "email.com", startDate: "2019-12-17 00:00:00", endDate: "2019-12-18 23:41:06", vehicleID: "ford_focus1", vehicleCost: 0.0)]


struct UserCredentials: Codable, Equatable {
    
    var userTypeID: Int
    
    var firstname: String
    var lastname: String
    let email: String
    let password: String
    
    func isEmpty() -> Bool {
        return email.isEmpty || password.isEmpty
    }
    
    func userType() -> UserTypes {
        return usertypes[userTypeID]
    }
    
    init() {
        self.init(firstname: "", lastname: "", email: "", password: "", userTypeID: 0)
    }
    
    init(firstname: String, lastname: String, email: String, password: String, userTypeID: Int) {
        
        self.firstname = firstname
        self.lastname = lastname
        
        self.email = email
        self.password = password
        self.userTypeID = userTypeID
    }
    
    
    init(firstname: String, lastname: String, email: String, password: String) {
        self.init(firstname: firstname, lastname: lastname, email: email, password: password, userTypeID: 0)
    }
    
    mutating func changeUserType(newUserTypeID: Int) {
        self.userTypeID = newUserTypeID
    }
    
    static func == (lhs: UserCredentials, rhs: UserCredentials) -> Bool {
        return (lhs.email == rhs.email) && (lhs.password == rhs.password) && (lhs.userTypeID == rhs.userTypeID)
    }
    
}




extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
