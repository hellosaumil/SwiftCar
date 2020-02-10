//
//  HomePageView.swift
//  SwitCar
//
//  Created by Saumil Shah on 12/16/19.
//  Copyright © 2019 Saumil Shah. All rights reserved.
//

import SwiftUI

struct HomePageView: View {
    
    @EnvironmentObject var userData: UserData
    
    @State var userLoggedIn: Bool
    @State var selectedUserType: Int = 0
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            if !self.userLoggedIn {
                
                LoginView(userValidated: self.$userLoggedIn, loggedInUserType: self.$selectedUserType)
                    .environmentObject(self.userData)
                
                // MARK: Segmented Control
                VStack(alignment: .leading) {
                    
                    Text("You are a...")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 8)
                    
                    Picker(selection: self.$selectedUserType, label: Text("Pick a user type")) {
                        ForEach(0..<usertypes.count) { index in
                            Text(usertypes[index].rawValue).tag(index)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding(.vertical, 20)
                
            } else {
                
                if usertypes[self.selectedUserType] == .ridesharer {
                    
                    RiderView(userLoggedIn: self.$userLoggedIn)
                        .accentColor(.pink)
                        .environmentObject(self.userData)
                    
                } else if usertypes[self.selectedUserType] == .fleetowner {
                    
                    FleetOwnerView(userLoggedIn: self.$userLoggedIn)
                        .accentColor(.green)
                        .environmentObject(self.userData)
                    
                } else {
                    
                    Text("Invalid User")
                }
            }
        }
        .animation(.spring(dampingFraction: 0.8))
        
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        
        Group{
            //            HomePageView(userLoggedIn: true, selectedUserType: 0, currentUser: tempUser)
            //            HomePageView(userLoggedIn: true, selectedUserType: 1, currentUser: tempUser)
            //            HomePageView(userLoggedIn: false, currentUser: tempUser)
            HomePageView(userLoggedIn: false)
                .environmentObject(UserData())
        }
        .previewDevice("iPhone XS")
    }
}
