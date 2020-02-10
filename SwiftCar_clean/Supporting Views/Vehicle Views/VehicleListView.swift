//
//  VehicleListView.swift
//  SwitCar
//
//  Created by Saumil Shah on 12/16/19.
//  Copyright © 2019 Saumil Shah. All rights reserved.
//

import SwiftUI

struct VehicleListView: View {
    
    @EnvironmentObject var userDataObj: UserData
    @Binding var ofVehicles: [Vehicle]
    @State var imageScale: CGFloat = 0.85
    
    var body: some View {
        
        Group {
            
            VStack {
                
                Divider()
                
                List {
                    
                    ForEach(self.ofVehicles, id: \.self) { vehicle in
                        
                        VehicleView(vehicle: vehicle,
                                    vehicleLotLocation: findVehicleLocation(of: vehicle, from: self.userDataObj),
                                    imageScale: self.imageScale)
                            
                            .environmentObject(self.userDataObj)
                    }
                    
                }
                
            }
            
        }
        
    }
}

struct VehicleListView_Previews: PreviewProvider {
    static var previews: some View {
        VehicleListView(ofVehicles: .constant(vehicleListData))
            .environmentObject(UserData())
            .previewDevice("iPhone XS")
    }
}
