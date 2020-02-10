//
//  AssignLotsView.swift
//  SwitCar
//
//  Created by Saumil Shah on 12/17/19.
//  Copyright © 2019 Saumil Shah. All rights reserved.
//

import SwiftUI

struct AssignLotsView: View {
    
    @EnvironmentObject var userDataObj: UserData
    
    @State var selectedLot: Int = 0
    @State var showingSheet = false
    
    @State var selectedVehicle: Vehicle?
    
    var body: some View {
        
        Group {
            
            VStack(spacing: 0) {
                
                Divider()
                
                Group {
                    
                    Form {
                        
                        ForEach(self.userDataObj.availableVehicles, id: \.self) { vehicle in
                            
                            Section(header: Text("id: \(vehicle.vid)")) {
                                
                                BindingTextRowView(headline: .constant(vehicle.vehicleName), subheadline: .constant(findVehicleLocation(of: vehicle, from: self.userDataObj).subtitle), caption:.constant(findVehicleLocation(of: vehicle, from: self.userDataObj).title))
                                
                            }
                            .onTapGesture {
                                self.selectedVehicle = vehicle
                                self.showingSheet = true
                            }
                        }
                    }
                }
                .actionSheet(isPresented: $showingSheet) {
                    CreateActionSheet()
                }
            }
            .navigationBarTitle(Text("Assign Lots 📝"), displayMode: .automatic)
        } 
    }
    
    func CreateActionSheet() -> ActionSheet {
        
        var actionButtons = [ActionSheet.Button]()
        
        for lot in self.userDataObj.availableLots.sorted(by: { (p1, p2) -> Bool in
            p1.title < p2.title
        }) {
            
            actionButtons.append( .default( Text("\(lot.title) at \(lot.subtitle)"), action: {
                
                self.userDataObj.vehicleParkingInfo[self.selectedVehicle?.vid ?? "ford_focus"] = lot.title
                
                
                // MARK: Store Updated Lot Assignments
                DispatchQueue.main.async {
                    
                    do {
                        try saveLotAssignment(from: self.userDataObj.vehicleParkingInfo)
                        
                    } catch {
                        print("\nError while saving updated lot assignment\(error.localizedDescription)...\n")
                    }
                }
                
            } ))
        }
        
        actionButtons.append( .destructive(Text("Cancel")) )
        
        return ActionSheet(title: Text("Which parking lot do you want to assign?"),
                           message: Text("Select one from below"),
                           buttons: actionButtons )
    }
    
}

struct AssignLotsView_Previews: PreviewProvider {
    static var previews: some View {
        AssignLotsView()
            .environmentObject(UserData())
            .previewDevice("iPhone XS")
    }
}
