//
//  AvailableCarsView.swift
//  SwitCar
//
//  Created by Saumil Shah on 12/17/19.
//  Copyright © 2019 Saumil Shah. All rights reserved.
//

import SwiftUI

struct AvailableCarsView: View {
    
    @EnvironmentObject var userDataObj: UserData
    
    var body: some View {
        
        NavigationView {
            
            Group {
                
                List {
                    
                    ForEach(self.userDataObj.parkingLotInfo.map({$0.key}), id: \.self) { lotID in
                        
                        NavigationLink(destination:
                            
                            VehicleListView(ofVehicles: .constant( self.userDataObj.parkingLotInfo[lotID, default: []].map({ carID in self.userDataObj.availableVehicles.filter({ $0.vid == carID }).first! }) ))
                                .environmentObject(self.userDataObj)
                                .navigationBarTitle("Cars at \(lotID)", displayMode: .automatic)
                        ) {
                            
                            VStack(alignment: .leading) {
                                
                                Text("\(self.userDataObj.availableLots.filter({ $0.title == lotID }).first?.title ?? "---" )")
                                    .foregroundColor(.primary)
                                    .lineLimit(2)
                                    .font(.system(size: 18, design: .serif))
                                
                                Text("\(self.userDataObj.availableLots.filter({ $0.title == lotID }).first?.subtitle ?? "---" )")
                                    .foregroundColor(.secondary)
                                    .lineLimit(2)
                                    .font(.system(size: 16, design: .monospaced))
                            }
                        }
                    }
                }
                
            }
            .navigationBarTitle(Text("Available Cars"), displayMode: .automatic)
        }
    }
}

struct AvailableCarsView_Previews: PreviewProvider {
    static var previews: some View {
        AvailableCarsView()
            .environmentObject(UserData())
            .previewDevice("iPhone XS")
    }
}
