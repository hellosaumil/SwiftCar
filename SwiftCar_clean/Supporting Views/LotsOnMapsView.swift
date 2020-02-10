//
//  LotsOnMapsView.swift
//  SwiftCar
//
//  Created by Saumil Shah on 12/15/19.
//  Copyright © 2019 Saumil Shah. All rights reserved.
//

import SwiftUI
import MapKit

struct LotsOnMapsView: View {
    
    @EnvironmentObject var userDataObj: UserData
    
    @State var currLoc: CLLocationCoordinate2D = CLLocationCoordinate2D(
        latitude: 32.7760, longitude: -117.0713)
    
    @State var listActive: Bool = false
    @Binding var color: Color
    
    @State var userType: UserTypes = .fleetowner
    
    var body: some View {
        
        ZStack {
            
            MapView(centerCoordinate: self.$currLoc,
                    annotations: self.userDataObj.availableLots.map({$0.getLotAnnotationPt()}))
                .edgesIgnoringSafeArea(.all)
                .onTapGesture(perform: { self.listActive = false })
            
            // MARK: Crosshairs
            Image(systemName: "plus")
                .font(.headline)
                .foregroundColor(self.color)
                .opacity(0.85)
                .frame(width: 32, height: 32)
            
            VStack(spacing: 0) {
                
                Button(action: {
                    self.listActive.toggle()
                }) {
                    RoundedButton(text: "Tap to See All Lots", color: self.color, foregroundColor: .white, font: .headline, scale: 1)
                }
                .offset(y: 10)
                
                withAnimation(.spring()) {
                    
                    List {
                        
                        Text("Available Lots").font(.title).bold()
                        
                        ForEach(self.userDataObj.availableLots, id: \.self) { location in
                            
                            Button(action: {
                                self.currLoc = location.locationCoordinate()
                            }) {
                                
                                VStack(alignment: .leading) {
                                    
                                    Text("\(location.title)")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    
                                    Text("\(location.subtitle)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }
                .cornerRadius(12)
                .padding()
                .frame(width: UIScreen.main.bounds.width * 0.95, height: 300)
                .opacity(self.listActive ? 1.0 : 0)
                
                Spacer()
                
                if self.userType == .fleetowner {
                 
                    HStack(alignment: .center, spacing: 0) {
                        
                        FloatingActionButton(systemImageName: "mappin", bgColor: self.$color, action: {
                            
                            let newTitle =  "Lot \(self.userDataObj.availableLots.count)"
                            let newSubtitle = "Location \(self.userDataObj.availableLots.count)"
                            
                            // MARK: Create a New Parking Lot
                            let newLoc = CustomAnnotationPoint(title: newTitle, subtitle: newSubtitle, coordinate: self.currLoc)
                            
                            if self.userDataObj.availableLots.filter({ $0.getLotAnnotationPt() == newLoc }).count == 0 {
                                
                                self.userDataObj.availableLots.append(ParkingLot(title: newTitle, subtitle: newSubtitle, coordinates: Coordinates(latitude: self.currLoc.latitude, longitude: self.currLoc.longitude)))
                            }
                        })
                        
                        RoundedButton(text: "Drop a Pin to Create Lot Location", color: .init(white: 0.98), foregroundColor: self.color, font: .caption, scale: 0.50)
                        .shadow(color: .primary, radius: 8)
                        
                    }.offset(y: -20)
                    
                }
            }

        }
    }
}

struct LotsOnMapsView_Previews: PreviewProvider {
    static var previews: some View {
        LotsOnMapsView(color: .constant(.orange))
            .environmentObject(UserData())
            .previewDevice("iPhone XS")
    }
}
