//
//  FleetManagementView.swift
//  SwitCar
//
//  Created by Saumil Shah on 12/17/19.
//  Copyright © 2019 Saumil Shah. All rights reserved.
//

import SwiftUI

struct FleetManagementView: View {
    
    @EnvironmentObject var userDataObj: UserData
    
    var body: some View {
        
        NavigationView {
            
            Group {
                
                List {
                    
                    NavigationLink(destination:
                        FleetView()
                        .environmentObject(self.userDataObj)
                        ) {
                        
                        Text("Current Fleet 🏢")
                    }
                    
                    NavigationLink(destination:
                        AssignLotsView()
                        .environmentObject(self.userDataObj)
                    ) {
                        
                        Text("Assign Lots 📝")
                    }
                    
                    NavigationLink(destination:
                        NewVehicleView()
                        .environmentObject(self.userDataObj)
                        ) {
                        
                        Text("Add Vehicle 🏎")
                    }
                    
                }
                
            }
            .navigationBarTitle(Text("Current Fleet 🏢"), displayMode: .automatic)
        }
    }
}

struct FleetManagementView_Previews: PreviewProvider {
    static var previews: some View {
        FleetManagementView()
            .environmentObject(UserData())
            .previewDevice("iPhone XS")
    }
}
