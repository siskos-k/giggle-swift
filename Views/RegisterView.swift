//
//  LoginView.swift
//  Giggle
//
//  Created by Konstantinos Siskos on 21/12/24.
//

import SwiftUI

struct RegisterView: View {
    
    @StateObject var registerVM = RegisterViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: UIScreen.main.bounds.width, height: 500)
                    .foregroundColor(Color.green)
                    .offset(y: -200)
                
                VStack {
                    HeaderView()
                        .offset(y: -100)
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color.white)
                            .frame(width: UIScreen.main.bounds.width-10, height: 55)
                        Text("Welcome! Fill in the form to start turning your passion into an income!")
                            .foregroundColor(Color.black)

                    }
                    Form {
                        TextField("Full Name", text: $registerVM.name)
                        TextField("Email Address", text: $registerVM.email)
                            .autocapitalization(.none)
                            .autocorrectionDisabled(true)
                        SecureField("Password", text: $registerVM.password)
                            .autocorrectionDisabled(true)
                            .autocapitalization(.none)
                        
                        Button(action: {
                            registerVM.register()
                        }) {
                            Text("Register")
                                .bold()
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    
                  
                }
            }
        }
        Spacer()
    }
}

#Preview {
    RegisterView()
}
