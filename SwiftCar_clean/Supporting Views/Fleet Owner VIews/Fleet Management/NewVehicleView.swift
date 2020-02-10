//
//  NewVehicleView.swift
//  SwitCar
//
//  Created by Saumil Shah on 12/17/19.
//  Copyright © 2019 Saumil Shah. All rights reserved.
//

import SwiftUI

struct NewVehicleView: View {
    
    @EnvironmentObject var userDataObj: UserData
    
    @State var selectedVehicle: String = "ford_focus"
    @State var newPrice: Double = 7.5
    @State var newVehicleName: String = ""
    
    @State var alertTitle: String = ""
    @State var alertMessage: String = ""
    @State var showingAlert: Bool = false
    
    var body: some View {
        
        Group {
            
            VStack(spacing: 0) {
                
                Divider()
                
                Form {
                    
                    Section {
                        
                        Text("Vehicle Name").bold()
                        
                        commonUserInput(keyboard: .default, placeholder: "Type new vehicle name...", textfield: self.$newVehicleName, lineLimit: 1, fontDesign: .monospaced, fontSize: .subheadline, scale: 1.0)
                            .padding(.vertical)
                        
                    }
                    .onTapGesture {
                        self.endEditing(true)
                    }
                    
                    Section(header: Text("Choose your fleet")) {
                        
                        HStack(alignment: .center) {
                            
                            Spacer()
                            
                            CustomImageView(image: .constant(ImageStore.shared.getImage(name: self.selectedVehicle, scale: 1.0)), scale: .constant(0.65))
                            
                            Spacer()
                            
                        }
                            
                        .padding(.vertical)
                        
                        Text("Select a Fleet 🚚")
                        
                        
                        Picker(selection: self.$selectedVehicle, label: Text("")) {
                            
                            ForEach(self.userDataObj.currentFleet.map{$0.key}, id: \.self) { fleetID in
                                Text(fleetID).font(.system(size: 16, weight: .semibold, design: .monospaced))
                            }
                            .padding(.vertical, 0)
                        }
                        .frame(height: 150)
                        .scaledToFit()
                        .pickerStyle(WheelPickerStyle())
                    }
                    
                    Section {
                        
                        HStack {
                            
                            HStack {
                                
                                Text("Price:").bold()
                                Text("$\(self.getPriceFormatted)/hr")
                                    .font(.system(.headline, design: .monospaced))
                            }
                            
                            Stepper("", onIncrement: {
                                self.newPrice += 0.5
                                print("Adding to age")
                            }, onDecrement: {
                                self.newPrice -= 0.5
                                print("Subtracting from age")
                            })
                            
                        }
                    }
                }
                
                VStack(spacing: 8) {
                    Divider().padding(.bottom, 16)
                    
                    // MARK: Create a New Vehicle
                    Button(action: {
                        self.createVehicle()
                    }) { RoundedButton(text: "Add to Fleet", color: .accentColor, foregroundColor: .white, font: .headline) }
                    
                    Text("Scroll to see vehicle properties")
                        .font(.system(.footnote, design: .monospaced))
                        .foregroundColor(.gray)
                }
                
            }.navigationBarTitle(Text("New Vehicle 🏎"))
                .onAppear(perform: {self.initVehicleProperties()})
                .alert(isPresented: self.$showingAlert, content: { self.invalidDataEntryAlert })
        }
        .accentColor(.green)
    }
    
    func raiseAlert(_ message: String, title: String = "Invalid Entry") {
        
        self.alertTitle = title
        self.alertMessage = message
        self.showingAlert = true
    }
    
    var invalidDataEntryAlert: Alert {
        
        return Alert(
            title: Text("\(self.alertTitle)"),
            message: Text("\(self.alertMessage)"),
            dismissButton: .cancel(
                Text("Dismiss").foregroundColor(.red),
                action: {
                    self.showingAlert.toggle()
                    self.alertMessage = ""
            }))
        
    }
    
    func initVehicleProperties() {
        
        self.selectedVehicle = "honda_civic"
        self.newPrice = 11.5
        self.newVehicleName = ""
    }
    
    func createVehicle() {
        
        guard self.newVehicleName != "" else {
            raiseAlert("Please Type in a Vehicle Name", title: "Vehicle Name Can't be Empty")
            return
        }
        
        let newVid = self.newVehicleName + "\(Int.random(in: 1..<1000))_\(self.newPrice)"
        
        let newVehicle = Vehicle(vid: newVid, vehicleName: self.newVehicleName, imageName: self.selectedVehicle, price: self.newPrice)
        
        guard self.userDataObj.availableVehicles.filter({ $0.vid == newVehicle.vid }).count == 0 else {
            raiseAlert("Vehicle Already Exists")
            return
        }
        
        // MARK: Store Updated Vehicles
        self.userDataObj.availableVehicles.append(newVehicle)
        self.userDataObj.currentFleet[ self.selectedVehicle ]?.append(newVehicle.vid)
        
        DispatchQueue.main.async {
            
            do { try saveVehicles(from: self.userDataObj.availableVehicles) } catch {
                print("\nError while saving updated vehicles\(error.localizedDescription)...\n") }
        }
        
        // MARK: Store Updated Fleet
        DispatchQueue.main.async {
            
            do { try saveFleet(from: self.userDataObj.currentFleet)
            } catch { print("\nError while saving updated vehicles\(error.localizedDescription)...\n") }
        }
        
        raiseAlert("Vehicle Created Successfully with ID: \(newVehicle.vid)", title: "Vehicle Created 🎉")
        
        self.initVehicleProperties()
    }
    
    private func endEditing(_ force: Bool) {
        UIApplication.shared.endEditing()
    }
    
    var getPriceFormatted: String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.roundingMode = .up
        
        return String(describing: formatter.string(from: NSNumber(value: self.newPrice)) ?? "0.0")
        
    }
    
    
}

struct NewVehicleView_Previews: PreviewProvider {
    static var previews: some View {
        NewVehicleView()
            .environmentObject(UserData())
            .previewDevice("iPhone XS")
    }
}
