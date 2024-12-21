//
//  LoginViewModel.swift
//  Giggle
//
//  Created by Konstantinos Siskos on 21/12/24.
//

import Foundation
import FirebaseAuth

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errormessage: String = ""
    init(){

}
    func login(){
        guard validate() else { return }
        Auth.auth().signIn(withEmail: email, password: password)
    }
    
    private func validate() -> Bool {
        
            guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
                  !password.trimmingCharacters(in: .whitespaces).isEmpty else{
                errormessage = "Please fill in all fields"
                return false
            }
            //email includes . and @
            guard email.contains(".") && email.contains("@") else{
                errormessage = "Please add a valid email address."
                return false
            }
            return true
    }
}
