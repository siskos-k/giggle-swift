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

    init() {}

    func login() {
        guard validate() else { return }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.handleAuthError(error)
                    return
                }

                // Clear error message if login is successful
                self?.errormessage = ""
            }
        }
    }

    private func handleAuthError(_ error: Error) {
        let nsError = error as NSError

        // Log the error for debugging purposes
        print("Login error: \(nsError), \(nsError.userInfo)")

        // Provide user-friendly error messages
        switch nsError.code {
        case AuthErrorCode.invalidEmail.rawValue:
            errormessage = "The email address is not valid. Please try again."
        case AuthErrorCode.userNotFound.rawValue:
            errormessage = "No user found with this email. Please check the email or sign up."
        case AuthErrorCode.wrongPassword.rawValue:
            errormessage = "Incorrect password. Please try again."
        default:
            errormessage = "An error occurred. Check your credentials and try again."
        }
    }

    private func validate() -> Bool {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            errormessage = "Please fill in all fields."
            return false
        }

        guard email.contains(".") && email.contains("@") else {
            errormessage = "Please enter a valid email address."
            return false
        }

        return true
    }
}
