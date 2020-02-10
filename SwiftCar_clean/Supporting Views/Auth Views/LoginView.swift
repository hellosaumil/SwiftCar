//
//  LoginView.swift
//  SwiftCar
//
//  Created by Saumil Shah on 12/14/19.
//  Copyright © 2019 Saumil Shah. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var userDataObj: UserData
    
    @State var emailField: String = ""
    @State var passwordField: String = ""
    
    @Binding var userValidated: Bool
    @Binding var loggedInUserType: Int
    
    @State var showingModal: Bool = false
    @State var showingAlert: Bool = false
    @State var alertMessage: String = ""
    
    var body: some View {
        
        NavigationView {
            
            Background {
                
                VStack {
                    
                    Divider()
                    
                    Group {
                        
                        VStack(alignment: .center, spacing: 10) {
                            
                            VStack(alignment: .leading, spacing: 5) {
                                
                                Text("Email").font(.headline).bold()
                                    .padding(.horizontal, 15)
                                
                                self.userInput(keyboard: .emailAddress, message: "", placeholder: "username@email.com", textfield: self.$emailField, lineLimit: 1, fontDesign: .monospaced)
                                
                            }.padding()
                            
                            VStack(alignment: .leading, spacing: 5) {
                                
                                Text("Password:").font(.headline).bold()
                                    .padding(.horizontal, 15)
                                
                                self.userInput(keyboard: .default, message: "", placeholder: "**********", textfield: self.$passwordField, lineLimit: 1, fontDesign: .monospaced, isSecure: true)
                                
                            }.padding()
                            
                            Text("A \(usertypes[self.loggedInUserType].rawValue)...").font(.subheadline)
                        }
                    }
                    //                    Spacer()
                    Divider()
                    
                    VStack(spacing: 16) {
                        
                        Button(action: {
                            print("Register Button Tapped!")
                            
                            // MARK: Register New User
                            self.showingModal.toggle()
                            
                        })
                        { RoundedButton(text: "New User? Register Here", color: Color(white: 0.96), foregroundColor: .accentColor, font: .subheadline) }
                        
                        
                        Button(action: {
                            print("Login Button Tapped!")
                            
                            // MARK: Authentic and Login
                            self.authenticateUser()
                            
                        }) { RoundedButton(text: "Login", font: .headline) }
                        
                    }
                    .padding(16)
                    
                    Spacer()
                    
                }
                    
                .navigationBarTitle("Login")
                    
                .alert(isPresented: self.$showingAlert, content: { self.invalidDataEntryAlert })
                .sheet(isPresented: self.$showingModal) {
                    
                    SignUpView(showModal: self.$showingModal,
                               emailField: self.$emailField,
                               passwordField: self.$passwordField,
                               newUserTypeID: self.$loggedInUserType)
                        .environmentObject(self.userDataObj)
                        
                        .accentColor( self.loggedInUserType == 0 ? .pink : .green )
                        .navigationBarTitle("Register")
                }
                    
                .accentColor( self.loggedInUserType == 0 ? .pink : .green )
                .navigationViewStyle(DefaultNavigationViewStyle())
                
            }
            .onTapGesture { self.endEditing(true) }
            
        }
    }
    
    var invalidDataEntryAlert: Alert {
        
        return Alert(
            title: Text("Invalid Entry"),
            message: Text("\(self.alertMessage)"),
            dismissButton: .cancel(
                Text("Dismiss").foregroundColor(.red),
                action: {self.showingAlert.toggle()}
            ))
    }
    
    func raiseAlert(_ message: String) {
        
        self.alertMessage = message
        self.showingAlert = true
    }
    
    func authenticateUser() {
        
        if self.emailField.isEmpty || self.passwordField.isEmpty { self.raiseAlert("Email or Password can't be empty!"); return }
        
        
//        if self.userDataObj.currentUser.isEmpty() {
//            
//            self.raiseAlert("Credentials can't be empty!")
//            return
//        }
        
//        guard self.userDataObj.registerdUsers.contains(self.userDataObj.currentUser) else {
        
        guard let foundUser = self.userDataObj.registerdUsers.filter({$0.email == self.emailField && $0.password == self.passwordField && $0.userTypeID == self.loggedInUserType}).first else {
            
            raiseAlert("Email and/or Password incorrect or You are not a \(usertypes[self.loggedInUserType].rawValue)"); return
        }
        
        self.userDataObj.currentUser = foundUser
        
        self.userValidated.toggle()
    }
    
    private func endEditing(_ force: Bool) {
        UIApplication.shared.endEditing()
    }
    
    private func userInput(keyboard keyboardDataType: UIKeyboardType = .default, message txt_msg:String="Text Message:", placeholder tf_msg:String="Placeholder Message", textfield tfTextBinding:Binding<String>, lineLimit:Int = 1, fontDesign:Font.Design = .monospaced, isSecure: Bool = false) -> some View {
        
        
        HStack(spacing: 0) {
            
            if txt_msg != "" {
                Text(txt_msg)
                    .font(.body).bold()
                
                Spacer()
            }
            
            Group {
                
                if isSecure {
                    
                    SecureField(tf_msg, text: tfTextBinding) {
                        self.endEditing(true)
                        tfTextBinding.wrappedValue = tfTextBinding.wrappedValue.trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.85, height: 20*CGFloat(lineLimit))
                    .lineLimit(lineLimit)
                    .textContentType(.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: 15, design: fontDesign))
                    .keyboardType(keyboardDataType)
                    
                } else {
                    
                    TextField(tf_msg, text: tfTextBinding, onEditingChanged: { _ in
                        
                        tfTextBinding.wrappedValue = tfTextBinding.wrappedValue.trimmingCharacters(in: .whitespacesAndNewlines)
                        
                    }) { self.endEditing(true) }
                        .frame(width: UIScreen.main.bounds.width * 0.85, height: 20*CGFloat(lineLimit))
                        .lineLimit(lineLimit)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.system(size: 15, design: fontDesign))
                        .keyboardType(keyboardDataType)
                }
            }
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        
        LoginView(userValidated: .constant(false), loggedInUserType: .constant(0))
        
//        Group {
//
//            LoginView(userValidated: .constant(false), loggedInUserCredentials: .constant(tempUser),
//                      loggedInUserType: .constant(0))
//                .environmentObject(UserData())
//
//            LoginView(userValidated: .constant(false), loggedInUserCredentials: .constant(tempUser),
//                      loggedInUserType: .constant(1))
//                .environmentObject(UserData())
//
//        }
        .previewDevice("iPhone Xs")
    }
}
