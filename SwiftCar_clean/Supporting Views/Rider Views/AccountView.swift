//
//  AccountView.swift
//  SwiftCar
//
//  Created by Saumil Shah on 12/15/19.
//  Copyright © 2019 Saumil Shah. All rights reserved.
//

import SwiftUI

struct AccountView: View {
    
    @EnvironmentObject var userDataObj: UserData
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        
        NavigationView {
            
            VStack(spacing: 0) {
                
                Divider()
                
                Group {
                    
                    Form {
                        
                        Section(header: Text("You are a...")) {
                            Text(self.userDataObj.currentUser.userType().rawValue)
                        }
                        
                        Section(header: Text("Basic Info")) {
                            
                            TextRowView(headline: "First Name", subheadline: self.userDataObj.currentUser.firstname)
                            TextRowView(headline: "Last Name", subheadline: self.userDataObj.currentUser.lastname)
                        }
                        
                        Section(header: Text("Login Info")) {
                            
                            TextRowView(headline: "Email", subheadline: self.userDataObj.currentUser.email)
                            TextRowView(headline: "Password", subheadline: self.userDataObj.currentUser.password)
                        }
                        
                        // MARK: Sign Out User
                        Section(footer: CopyRightView()) {
                            
                            Button(action: {
                                self.isLoggedIn.toggle()
                            }) { Text("Sign Out").foregroundColor(.red) }
                        }
                    }
                    
                }
            }
            .navigationBarTitle(Text("Account Info"), displayMode: .automatic)
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(isLoggedIn: .constant(true))
            .environmentObject(UserData())
            .previewDevice("iPhone XS")
    }
}

struct TextRowView: View {
    
    @State var headline: String
    @State var subheadline: String
    
    @State var caption: String = ""
    
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

struct CopyRightView: View {
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 6) {
            
            Text("SwiftCar for using SwiftUI")
            
            Text("<Code> by Saumil Shah")
            
        }.padding(.vertical, 4)
    }
}
