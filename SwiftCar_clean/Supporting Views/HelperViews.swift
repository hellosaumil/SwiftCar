//
//  HelperViews.swift
//  SwiftCar
//
//  Created by Saumil Shah on 12/15/19.
//  Copyright © 2019 Saumil Shah. All rights reserved.
//

import SwiftUI

//struct HelperViews: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//struct HelperViews_Previews: PreviewProvider {
//    static var previews: some View {
//        HelperViews()
//    }
//}

func findVehicleLocation(of vehicle: Vehicle, from userDataObj: UserData) -> ParkingLot {
    
    let parkingLotTitle = userDataObj.vehicleParkingInfo[vehicle.vid, default: "Lot XXX"]
    
    return userDataObj.availableLots.filter({ $0.title == parkingLotTitle}).first ?? emptyLot
}


func tabItemGroup(itemText: String, systemName: String) -> some View {
    
    VStack {
        Text(itemText)
        getSystemImage(systemName, font: .body)
    }
    
}

func getSystemImage(_ systemName: String = "photo", color:Color = .primary) -> some View {
    
    getSystemImage(systemName, color, .body)
}


func getSystemImage(_ systemName: String = "photo", font:Font = .body) -> some View {
    
    getSystemImage(systemName, .primary, font)
}

func getSystemImage(_ systemName: String = "photo", _ color:Color = .primary, _ font:Font = .title, scale: Image.Scale = .medium) -> some View {
    Image(systemName: systemName)
        .foregroundColor(color)
        .font(font)
        .imageScale(scale)
        .padding()
}

struct Background<Content: View>: View {
    private var content: Content
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct RoundedButton: View {
    
    @State var text: String
    @State var color: Color = .accentColor
    @State var foregroundColor: Color = .white
    @State var font:Font = .body
    @State var scale: CGFloat = 1.0
    
    var body: some View {
        Text(self.text)
            .font(font)
            .fontWeight(.semibold)
            .padding()
            .frame(width: UIScreen.main.bounds.width * 0.88 * self.scale )
            .foregroundColor(foregroundColor)
            .background(color)
            .cornerRadius(14)
    }
}

func commonUserInput(keyboard keyboardDataType: UIKeyboardType = .default, placeholder tf_msg:String="Placeholder Message", textfield tfTextBinding:Binding<String>, lineLimit:Int = 1, fontDesign:Font.Design = .monospaced, fontSize:Font.TextStyle = .body, scale: CGFloat = 1.0) -> some View {
    
    
    TextField(tf_msg, text: tfTextBinding, onEditingChanged: { _ in
        
        tfTextBinding.wrappedValue = tfTextBinding.wrappedValue.trimmingCharacters(in: .whitespacesAndNewlines)
        
    })
        .frame(width: UIScreen.main.bounds.width * 0.88 * scale, height: 10*CGFloat(lineLimit))
        .lineLimit(lineLimit)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .font(.system(fontSize, design: fontDesign))
        .keyboardType(keyboardDataType)
}

struct FloatingActionButton: View {
    
    var systemImageName: String = "plus"
    @Binding var bgColor: Color
    var color: Color = .white
    var font: Font = .body
    
    var action: () -> Void
    
    var body: some View {
        
        Button(action: action) { 
            getSystemImage(self.systemImageName, self.color, self.font, scale: .medium)
                .background(self.bgColor)
            .clipShape(Circle())
            .padding(.horizontal)
            .shadow(color: .primary, radius: 8)
        }
    }
}

struct BindingTextRowView: View {
    
    @Binding var headline: String
    @Binding var subheadline: String
    @Binding var caption: String
    
    var body: some View {
        
        HStack {
            
            Text(self.headline).bold()
            
            Spacer()
            
            if self.caption == "" {
                
                Text("\(self.subheadline)")
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .font(.system(size: 16, design: .monospaced))
                
            } else {
                
                VStack(alignment: .trailing) {
                    
                    Text("\(self.subheadline)")
                        .foregroundColor(.gray)
                        .lineLimit(2)
                        .font(.system(size: 16, design: .serif))
                    
                    Text("\(self.caption)")
                        .foregroundColor(.gray)
                        .lineLimit(2)
                        .font(.system(size: 14, design: .monospaced))
                    
                }
            }
        }
    }
}
