//
//  TripsView.swift
//  SwiftCar
//
//  Created by Saumil Shah on 12/15/19.
//  Copyright © 2019 Saumil Shah. All rights reserved.
//

import SwiftUI

struct TripsView: View {
    
    @EnvironmentObject var userDataObj: UserData
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                Text("Trips would have appeared here...")
                
                
            }.navigationBarTitle(Text("My Trips"), displayMode: .automatic)
            
        }
    }
}

struct TripsView_Previews: PreviewProvider {
    static var previews: some View {
        TripsView()
            .environmentObject(UserData())
    }
}
