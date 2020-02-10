//
//  VehicleView.swift
//  SwitCar
//
//  Created by Saumil Shah on 12/16/19.
//  Copyright © 2019 Saumil Shah. All rights reserved.
//

import SwiftUI

struct VehicleView: View {
    
    @EnvironmentObject var userDataObj: UserData
    
    @State var vehicle: Vehicle
    @State var vehicleLotLocation: ParkingLot
    
    @State var imageScale: CGFloat = 1.0
    
    @State var alertTitle: String = ""
    @State var alertMessage: String = ""
    @State var showingAlert: Bool = false
    
    var body: some View {
        
        Group {
            
            VStack {
                
                TextRowView(headline: self.vehicle.vehicleName, subheadline: "")
                    .font(.title)
                
                
                CustomImageView(image: .constant(self.vehicle.vehicleImage), scale: self.$imageScale)
                
            }.padding(.bottom, 10)
            
            VStack {
                
                VStack {
                    
                    TextRowView(headline: "Vehicle ID:", subheadline: self.vehicle.vid)
                    
                    Divider()
                    
                    TextRowView(headline: "Location:", subheadline: self.vehicleLotLocation.subtitle, caption: self.vehicleLotLocation.title)
                    
                    MapView(centerCoordinate: .constant( self.vehicleLotLocation.locationCoordinate() ),
                            annotations: [self.vehicleLotLocation.getLotAnnotationPt()],
                            isMovable: false)
                        .frame(height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.clear, lineWidth: 2))
                    
                }
                
                Divider()
                
                TextRowView(headline: "Price:", subheadline: "$\(self.vehicle.price)/hr")
                
                Divider()
                
                
                if usertypes[self.userDataObj.currentUser.userTypeID] == .ridesharer {
                    
                    //                    BindingTextRowView(headline: .constant("Availabilty:"), subheadline: .constant( self.vehicle.vid == (self.userDataObj.VehicleInUse?[self.userDataObj.currentUser.email]?.vid ?? "***")                     ? "Already in Use" : "Available" ), caption: .constant(""))
                    
                    BindingTextRowView(headline: .constant("Availabilty:"), subheadline: .constant( self.userDataObj.VehicleInUse?.filter({ (arg0) -> Bool in
                        let (_, value) = arg0
                        return (value.vid == self.vehicle.vid)
                    }).count ?? 0 > 0 ? "Already In Use" : "Available" ), caption: .constant(""))
                    
                    
                } else {
                    
                    BindingTextRowView(headline: .constant("Availabilty:"), subheadline: .constant( self.userDataObj.VehicleInUse?.filter({ (arg0) -> Bool in
                        let (_, value) = arg0
                        return value.vid == self.vehicle.vid
                    }).count ?? 0 > 0 ? "In Use" : "Available" ), caption: .constant(""))
                }
                
                
            }
            
            
            if usertypes[self.userDataObj.currentUser.userTypeID] == .ridesharer {
                
                Button(action: {
                    
                    
                    // MARK: Reserve Car
                    if self.userDataObj.VehicleInUse?.contains(where: { $0.key == self.userDataObj.currentUser.email }) ?? false {
                        
                        if self.userDataObj.VehicleInUse?[self.userDataObj.currentUser.email]?.vid ?? tempCar.vid != self.vehicle.vid {
                            
                            self.raiseAlert("You have aleady reserved another car!", title: "Already driving another car ⚠️")
                            
                        } else {
                            
                            self.raiseAlert("Attempting to return this car...", title: "Initiating Return 🚗")
                            
                            self.userDataObj.VehicleInUse?.removeValue(forKey: self.userDataObj.currentUser.email)
                            
                            // MARK: Return Used Vehicle
                            DispatchQueue.main.async {
                                
                                self.raiseAlert("Car Return Successful!", title: "Car Returned")
                                
                                do {
                                    try saveUsedVehicle(from: self.userDataObj.VehicleInUse)
                                    
                                } catch {
                                    print("\nReturn Car: Error while saving used vehicle\(error.localizedDescription)...\n")
                                }
                            }
                            
                            // MARK: End a Trip
                            if !self.userDataObj.allTrips.isEmpty {
                                
                                var oldTrips:[Trip]? = self.userDataObj.allTrips[self.userDataObj.currentUser.email]
                                
                                if oldTrips != nil {
                                    
                                    if let tripIndex = oldTrips?.firstIndex(where: { (item) -> Bool in
                                        item.vehicleID == self.vehicle.vid
                                    }) {
                                        
                                        // MARK: Definitely end a trip
                                        oldTrips?[tripIndex].endTrip()
                                        self.userDataObj.allTrips[self.userDataObj.currentUser.email] = oldTrips
                                    }
                                }
                                
                            }
                            
                        }
                        
                    } else {
                        
                        if self.userDataObj.VehicleInUse != nil {
                            
                            self.userDataObj.VehicleInUse![self.userDataObj.currentUser.email] = self.vehicle
                            
                        } else {
                            
                            let tempdict:[String: Vehicle] = [self.userDataObj.currentUser.email : self.vehicle]
                            self.userDataObj.VehicleInUse = tempdict
                        }
                        
                        // MARK: Store Used Vehicle
                        DispatchQueue.main.async {
                            
                            do {
                                try saveUsedVehicle(from: self.userDataObj.VehicleInUse)
                                
                            } catch {
                                print("\nError while saving used vehicle\(error.localizedDescription)...\n")
                            }
                        }
                        
                        
                        // MARK: Start a Trip
                        let newTrip = Trip(userEmail: self.userDataObj.currentUser.email, startDate: getCurrentDateAndTime(), endDate: "", vehicleID: self.vehicle.vid, vehicleCost: self.vehicle.price)
                        
                        if !self.userDataObj.allTrips.isEmpty {
                            
                            if let oldTrips:[Trip] = self.userDataObj.allTrips[self.userDataObj.currentUser.email] {
                                
                                self.userDataObj.allTrips[self.userDataObj.currentUser.email] = [newTrip] + oldTrips
                            }
                            
                        } else {
                            
                            self.userDataObj.allTrips[self.userDataObj.currentUser.email] = [newTrip]
                        }
                    }
                    
                }) {
                    
                    //                    Text(self.vehicle.vid == (self.userDataObj.VehicleInUse?[self.userDataObj.currentUser.email]?.vid ?? "***") ? "Return Car" : "Reserve Car")
                    //                        .font(.headline)
                    //                        .foregroundColor( self.vehicle.vid == (self.userDataObj.VehicleInUse?[self.userDataObj.currentUser.email]?.vid ?? "***")                     ? Color.pink : Color.green)
                    
                    
                    
                    Group {
                        
                        if self.userDataObj.VehicleInUse?.filter({ (arg0) -> Bool in
                            let (_, value) = arg0
                            return (value.vid == self.vehicle.vid)}).count ?? 0 > 0 {
                            
                            if self.vehicle.vid == self.userDataObj.VehicleInUse?[self.userDataObj.currentUser.email]?.vid ?? "***" {
                                Text("Return Car")
                                
                            } else { Text("Car already in use") }
                            
                        } else { Text("Reserve Car") }
                        
                        //                        Text(self.vehicle.vid == (self.userDataObj.VehicleInUse?[self.userDataObj.currentUser.email]?.vid ?? "***") ? "Return Car" : "Reserve Car")
                        
                        
                        //                        Text(self.userDataObj.VehicleInUse?.filter({ (arg0) -> Bool in
                        //                            let (key, value) = arg0
                        //                            return (value.vid == self.vehicle.vid) && (key == self.userDataObj.currentUser.email)
                        //
                        //                        }).count ?? 0 > 0 ? "Return Car" : "Reserve Car")
                        
                    }
                    .font(.headline)
                    .foregroundColor( self.vehicle.vid == (self.userDataObj.VehicleInUse?[self.userDataObj.currentUser.email]?.vid ?? "***")                     ? Color.pink : Color.green)
                    .padding(.vertical)
                }
                .disabled(self.userDataObj.VehicleInUse?.filter({ (arg0) -> Bool in
                    let (key, value) = arg0
                    return (value.vid == self.vehicle.vid) && (key != self.userDataObj.currentUser.email) }).count ?? 0 > 0)
                
            } else { EmptyView() }
            
        }
        .alert(isPresented: self.$showingAlert, content: { self.invalidDataEntryAlert })
    }
    
    func raiseAlert(_ message: String, title: String = "Invalid Entry") {
        
        self.alertTitle = title
        self.alertMessage = message
        self.showingAlert = true
    }
    
    var invalidDataEntryAlert: Alert {
        
        return Alert(
            title: Text("\(self.alertTitle)"),
            message: Text("\(self.alertMessage)"),
            dismissButton: .cancel(
                Text("Dismiss").foregroundColor(.red),
                action: {
                    self.showingAlert.toggle()
                    self.alertMessage = ""
            }))
        
    }
}

let testVehicle = vehicleListData[0]
let testLot = parkingLotsData[1]


struct VehicleView_Previews: PreviewProvider {
    static var previews: some View {
        VehicleView(vehicle: testVehicle, vehicleLotLocation: testLot)
            .environmentObject(UserData())
            .previewDevice("iPhone XS")
    }
}


struct CustomImageView: View {
    
    @Binding var image: Image?
    @Binding var scale: CGFloat
    
    var body: some View {
        
        Group {
            
            if self.image == Image(systemName: "xmark.rectangle") {
                
                Text("No Image Found or taking too long to load").font(.system(size: 14)).foregroundColor(.gray).bold().padding()
                
            } else {
                
                self.image?
                    .resizable()
                    .font(.system(size: 10, weight: .ultraLight))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width * self.scale, alignment: .center)
                    .offset(x: -8)
                    .shadow(color: Color.init(white: 0.65), radius: 10)
            }
        }
    }
}
