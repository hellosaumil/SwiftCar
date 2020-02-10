//
//  FleetOwnerView.swift
//  SwiftCar
//
//  Created by Saumil Shah on 12/16/19.
//  Copyright © 2019 Saumil Shah. All rights reserved.
//

import SwiftUI

struct FleetOwnerView: View {
    
    @EnvironmentObject var userDataObj: UserData
    
    @Binding var userLoggedIn: Bool
    @State var selectedView: Int = 1
    
    var body: some View {
        
        TabView(selection: self.$selectedView) {
            
            LotsOnMapsView(color: .constant(.green), userType: UserTypes.fleetowner)
                .environmentObject(self.userDataObj)
                .tabItem {
                    tabItemGroup(itemText: "All Lots", systemName: self.selectedView == 1 ? "rectangle.stack.fill" : "rectangle.stack" )
            }.tag(1)
            
            FleetManagementView()
                .environmentObject(self.userDataObj)
                .tabItem {
                    tabItemGroup(itemText: "Mange Fleet", systemName: self.selectedView == 2 ? "tram.fill" : "tram.fill" )
            }.tag(2)
            
            NavigationView {
                VehicleListView(ofVehicles: .constant(self.userDataObj.availableVehicles))
                    .environmentObject(self.userDataObj)
                    .navigationBarTitle("All Cars", displayMode: .automatic)
            }
            .tabItem {
                tabItemGroup(itemText: "All Cars", systemName: self.selectedView == 3 ? "car.fill" : "car" )
            }.tag(3)

            AccountView(isLoggedIn: self.$userLoggedIn)
                .environmentObject(self.userDataObj)
                .tabItem {
                    tabItemGroup(itemText: "Account", systemName: self.selectedView == 4 ? "person.fill" : "person" )
            }.tag(4)
        }
        .edgesIgnoringSafeArea(.top)
        .accentColor(.green)
    }
    
}

struct FleetOwnerView_Previews: PreviewProvider {
    static var previews: some View {

        FleetOwnerView(userLoggedIn: .constant(true))
            .environmentObject(UserData())
            .previewDevice("iPhone XS")
    }
}
