//
//  SignUpView.swift
//  SwiftCar
//
//  Created by Saumil Shah on 12/14/19.
//  Copyright © 2019 Saumil Shah. All rights reserved.
//

import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject var userDataObj: UserData
    @Binding var showModal: Bool
    
    @State var fnameField: String = ""
    @State var lnameField: String = ""
    
    @Binding var emailField: String
    @Binding var passwordField: String

    @Binding var newUserTypeID: Int
    
    @State var alertTitle: String = ""
    @State var alertMessage: String = ""
    @State var showingAlert: Bool = false
    @State var userCreated: Bool = false
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            HStack {
                
                Text("Register").font(.largeTitle).bold()
                
                Spacer()
                
                Button(action: { self.showModal.toggle() }) {
                    getSystemImage("xmark.circle.fill", .accentColor, .body).padding(.vertical, 16)
                }
                
            }.padding(.horizontal, 16)
            
            Divider()
            
            VStack(alignment: .leading) {
                Text("You are a... \(usertypes[self.newUserTypeID].rawValue)")
                    .font(.subheadline)
                    .bold()
                
                Picker(selection: self.$newUserTypeID, label: Text("")) {
                    ForEach(0..<usertypes.count) { index in
                        Text(usertypes[index].rawValue).tag(index)
                    }
                    .padding()
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding()
            
            Background {
                
                VStack(alignment: .center, spacing: 0) {
                    
                    self.userInput(keyboard: .namePhonePad, message: "First Name: ", placeholder: "Enter First Name", textfield: self.$fnameField, lineLimit: 1, fontDesign: .serif)
                    
                    self.userInput(keyboard: .namePhonePad, message: "Last Name: ", placeholder: "Enter Last Name", textfield: self.$lnameField, lineLimit: 1, fontDesign: .serif)
                    
                    Divider().padding(.vertical, 8)
                    
                    self.userInput(keyboard: .emailAddress, message: "Email: ", placeholder: "username@email.com", textfield: self.$emailField, lineLimit: 1, fontDesign: .monospaced)
                    
                    self.userInput(keyboard: .default, message: "Password: ", placeholder: "**********", textfield: self.$passwordField, lineLimit: 1, fontDesign: .monospaced)
                    
                }.padding(2)
                
                Divider().padding(.vertical, 8)
                Spacer()
                
                
                VStack(alignment: .center, spacing: 0) {
                    
                    Text( (self.fnameField.isEmpty || self.lnameField.isEmpty ||
                        self.emailField.isEmpty || self.passwordField.isEmpty) ? "Please provide all the information" : self.alertMessage)
                        .font(.subheadline)
                        .foregroundColor( (self.fnameField.isEmpty || self.lnameField.isEmpty ||
                            self.emailField.isEmpty || self.passwordField.isEmpty) ? .secondary : .accentColor)
                        .frame(width: UIScreen.main.bounds.width * 0.8)
                        .padding()
                    
                    Divider()
                    
                    Button(action: {
                        print("Signup Button Tapped!")
                        
                        // MARK: Sign up new user info to cloud
                        self.uploadUser()
                        
                    }) { RoundedButton(text: "Create Profile", font: .subheadline) }
                        .padding()
                        .disabled( (self.fnameField.isEmpty || self.lnameField.isEmpty ||
                            self.emailField.isEmpty || self.passwordField.isEmpty) )
                    
                }
            }
            .onTapGesture { self.endEditing(true) }
            
        }
        .onAppear(perform: {
            
            self.userCreated = false
            
            //            self.fnameField = self.userDataObj.currentUser.firstname
            //            self.lnameField = self.userDataObj.currentUser.lastname
            //            self.emailField = self.userDataObj.currentUser.email
            //            self.passwordField = self.userDataObj.currentUser.password
            //            self.newUserTypeID = self.userDataObj.currentUser.userTypeID
        })
            .alert(isPresented: self.$showingAlert, content: { self.invalidDataEntryAlert })
        
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
                    if self.userCreated { self.showModal.toggle() }
                    self.alertMessage = ""
            }))
        
    }
    
    private func uploadUser() {
        
        self.alertMessage = ""
        
        let newValidUserCred:UserCredentials = UserCredentials(firstname: self.fnameField, lastname: self.lnameField, email: self.emailField, password: self.passwordField, userTypeID: self.newUserTypeID)
        
        
        if self.userDataObj.registerdUsers.contains(where: { $0.email == newValidUserCred.email }) {
            
            raiseAlert("Email already in use...!"); return
        }
        
        
        self.userDataObj.registerdUsers.append(newValidUserCred)
        //        self.$userData.currentUser = newValidUserCred
        
        do {
            
            try saveUserCredListData(from: self.userDataObj.registerdUsers)
            self.userCreated = true
            
            raiseAlert("User Created Sucessfully!", title: "Profile Created!")
            
        } catch {
            print("\nError while saving updated user credentials\(error.localizedDescription)...\n")
        }
        
    }
    
    private func endEditing(_ force: Bool) {
        UIApplication.shared.endEditing()
    }
    
    private func userInput(keyboard keyboardDataType: UIKeyboardType = .default, message txt_msg:String="Text Message:", placeholder tf_msg:String="Placeholder Message", textfield tfTextBinding:Binding<String>, lineLimit:Int = 1, fontDesign:Font.Design = .monospaced, padding: CGFloat = 14.0) -> some View {
        
        
        HStack(spacing: 0) {
            
            if txt_msg != "" {
                Text(txt_msg)
                    .font(.system(size: 15))
                    .bold()
                    .lineLimit(1)
                
                Spacer()
            }
            
            TextField(tf_msg, text: tfTextBinding, onEditingChanged: { _ in
                
                tfTextBinding.wrappedValue = tfTextBinding.wrappedValue.trimmingCharacters(in: .whitespacesAndNewlines)
                
            }) {
                self.endEditing(true)
            }
            .frame(width: UIScreen.main.bounds.width * 0.65, height: 20*CGFloat(lineLimit))
            .lineLimit(lineLimit)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .font(.system(size: 15, design: fontDesign))
            .keyboardType(keyboardDataType)
            
        }
        .padding(padding)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        
        SignUpView(showModal: .constant(true), emailField: .constant(""), passwordField: .constant(""), newUserTypeID: .constant(0))
            .previewDevice("iPhone XS")
    }
}
