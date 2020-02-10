//
//  RiderView.swift
//  SwiftCar
//
//  Created by Saumil Shah on 12/16/19.
//  Copyright © 2019 Saumil Shah. All rights reserved.
//

import SwiftUI

struct RiderView: View {
    
    @EnvironmentObject var userDataObj: UserData
    
    @Binding var userLoggedIn: Bool
    @State var selectedView: Int = 2
    
    var body: some View {
        
        TabView(selection: self.$selectedView) {
            
            LotsOnMapsView(color: .constant(.pink), userType: UserTypes.ridesharer)
                .environmentObject(self.userDataObj)
                .tabItem {
                    tabItemGroup(itemText: "Map", systemName: self.selectedView == 1 ? "map.fill" : "map" )
            }.tag(1)
            
            AvailableCarsView()
                .environmentObject(self.userDataObj)
                .tabItem {
                    tabItemGroup(itemText: "Available Cars", systemName: self.selectedView == 2 ? "rectangle.stack.fill" : "rectangle.stack" )
            }.tag(2)
            
            DriveView()
                .environmentObject(self.userDataObj)
                .tabItem {
                    tabItemGroup(itemText: "Drive", systemName: self.selectedView == 3 ? "car.fill" : "car" )
            }.tag(3)
            
            TripsView()
                .environmentObject(self.userDataObj)
                .tabItem {
                    tabItemGroup(itemText: "Trips", systemName: self.selectedView == 4 ? "rectangle.stack.person.crop.fill" : "rectangle.stack.person.crop" )
            }.tag(4)
            
            AccountView(isLoggedIn: self.$userLoggedIn)
                .environmentObject(self.userDataObj)
                .tabItem {
                    tabItemGroup(itemText: "Account", systemName: self.selectedView == 5 ? "person.fill" : "person" )
            }.tag(5)
        }
        .edgesIgnoringSafeArea(.top)
    }
}

struct RiderView_Previews: PreviewProvider {
    static var previews: some View {
        
        RiderView(userLoggedIn: .constant(true))
            .environmentObject(UserData())
            .previewDevice("iPhone XS")
    }
}
