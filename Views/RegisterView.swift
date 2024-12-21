//
//  LoginView.swift
//  Giggle
//
//  Created by Konstantinos Siskos on 21/12/24.
//

import SwiftUI

struct RegisterView: View {
    
    @State var email: String = ""
    @State var password: String = ""
    @State var name: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: UIScreen.main.bounds.width, height: 500)
                    .foregroundColor(Color.green)
                    .offset(y: -200)
                
                VStack {
                    HeaderView()
                        .offset(y: -50)
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color.white)
                            .frame(width: UIScreen.main.bounds.width-10, height: 55)
                        Text("Welcome! Fill in the form to start turning your passion into an income!")
                            .foregroundColor(Color.black)

                    }
                    Form {
                        TextField("Full Name", text: $name)
                        TextField("Email Address", text: $email)
                            .autocapitalization(.none)
                            .autocorrectionDisabled(true)
                        SecureField("Password", text: $password)
                            .autocorrectionDisabled(true)
                            .autocapitalization(.none)
                        
                        Button(action: {
                            // Add login action
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
