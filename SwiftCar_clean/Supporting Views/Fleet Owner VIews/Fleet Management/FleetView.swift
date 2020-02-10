//
//  FleetView.swift
//  SwitCar
//
//  Created by Saumil Shah on 12/17/19.
//  Copyright © 2019 Saumil Shah. All rights reserved.
//

import SwiftUI

struct FleetView: View {
    
    @EnvironmentObject var userDataObj: UserData
    
    var body: some View {
        
        Group {
            
            VStack(spacing: 0) {
                
                Divider()
                
                Group {
                    
                    Form {
                        
                        ForEach(self.userDataObj.currentFleet.map{$0.key}, id: \.self) { fleetID in
                            
                            Section {
                                
                                Text(fleetID).font(.headline).bold()
                                
                                List {
                                    
                                    ForEach(self.userDataObj.currentFleet[fleetID, default: ["No Vehicles"]], id: \.self) { obj in
                                        
                                        Text("\(obj)")
                                            .font(.system(size: 14, design: .monospaced))
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                    }
                }
            }.navigationBarTitle(Text("Current Fleet 🏢"), displayMode: .automatic)
        }
    }
}

struct FleetView_Previews: PreviewProvider {
    static var previews: some View {
        FleetView()
        .environmentObject(UserData())
        .previewDevice("iPhone XS")
    }
}
