//
//  DriveView.swift
//  SwiftCar
//
//  Created by Saumil Shah on 12/15/19.
//  Copyright © 2019 Saumil Shah. All rights reserved.
//

import SwiftUI

struct DriveView: View {
    
    @EnvironmentObject var userDataObj: UserData
    
    var body: some View {
        
        NavigationView {
            
            VStack(alignment: .center) {
                
                if self.userDataObj.VehicleInUse?.contains(where: { $0.key == self.userDataObj.currentUser.email }) ?? false {
                    
                    List {
                        
                        VehicleView(vehicle: self.userDataObj.VehicleInUse?[self.userDataObj.currentUser.email] ?? tempCar,
                                    vehicleLotLocation: findVehicleLocation(of: self.userDataObj.VehicleInUse?[self.userDataObj.currentUser.email] ?? tempCar, from: self.userDataObj))
                            
                            .environmentObject(self.userDataObj)
                    }
                    
                } else {
                    
                    Text("No Reservations or Vehicle in Use! 🏎")
                }
            }
            .navigationBarTitle("Drive Info")
            
        }
    }
}
struct DriveView_Previews: PreviewProvider {
    static var previews: some View {
        DriveView()
            .environmentObject(UserData())
    }
}
