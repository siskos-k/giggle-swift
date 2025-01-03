//
//  LoginViewModel.swift
//  Giggle
//
//  Created by Konstantinos Siskos on 21/12/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errormessage: String = ""
    private let db = Firestore.firestore()
    
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
    func clearAllData() {
        db.collection("users").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching users: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No users found to delete.")
                return
            }
            
            for userDocument in documents {
                let userId = userDocument.documentID
                
                // Delete all gigs in the user's gigs sub-collection
                let gigsRef = self.db.collection("users").document(userId).collection("gigs")
                gigsRef.getDocuments { (gigSnapshot, error) in
                    if let error = error {
                        print("Error fetching gigs for user \(userId): \(error)")
                        return
                    }
                    
                    gigSnapshot?.documents.forEach { gigDocument in
                        gigsRef.document(gigDocument.documentID).delete { error in
                            if let error = error {
                                print("Error deleting gig \(gigDocument.documentID): \(error)")
                            }
                        }
                    }
                }
                
                // Delete the user document itself
                self.db.collection("users").document(userId).delete { error in
                    if let error = error {
                        print("Error deleting user \(userId): \(error)")
                    } else {
                        print("Successfully deleted user \(userId).")
                    }
                }
            }
        }
    }
    
}
