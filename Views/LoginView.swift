//
//  LoginView.swift
//  Giggle
//
//  Created by Konstantinos Siskos on 21/12/24.
//

import SwiftUI

struct LoginView: View {
    @StateObject var loginVM: LoginViewModel = .init()
    
    var body: some View {
        NavigationView {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: UIScreen.main.bounds.width, height: 500)
                    .foregroundColor(Color.green)
                    .offset(y: -200)
                
                VStack {
                    HeaderView()
                        .offset(y: -40)
                    
                    Form {
                        if !loginVM.errormessage.isEmpty {
                            Text(loginVM.errormessage)
                                .foregroundColor(Color.red)
                                .multilineTextAlignment(.center)
                        }
                        
                        TextField("Email Address", text: $loginVM.email)
                            .autocorrectionDisabled(true)
                            .autocapitalization(.none)
                        
                        SecureField("Password", text: $loginVM.password)
                            .autocorrectionDisabled(true)
                            .autocapitalization(.none)
                        
                        Button(action: {
                            loginVM.login()
                        }) {
                            Text("Log In")
                                .bold()
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    
                    VStack {
                        Text("First time here?")
                        NavigationLink("Create an account", destination: RegisterView())
                    }
                    
                    // Add new buttons below existing UI
                    Spacer()

                }
            }
            Spacer()
        }
    }
}

#Preview {
    LoginView()
}
