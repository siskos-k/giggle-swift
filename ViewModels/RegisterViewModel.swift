import FirebaseFirestore
import FirebaseAuth
import Foundation

class RegisterViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String = ""
    
    init() {}
    
    func register() {
        guard validate() else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.errorMessage = "Registration failed: \(error.localizedDescription)"
                return
            }
            
            guard let userId = result?.user.uid else {
                self?.errorMessage = "Failed to get user ID after registration."
                return
            }
            
            self?.insertUserRecord(id: userId)
        }
    }
    
    private func insertUserRecord(id: String) {
        let newUser = User(id: id, name: name, email: email, joined: Date().timeIntervalSince1970)
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(id)
            .setData(newUser.asDictionary()) { [weak self] error in
                if let error = error {
                    self?.errorMessage = "Failed to save user data: \(error.localizedDescription)"
                }
            }
    }
    
    private func validate() -> Bool {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Name cannot be empty."
            return false
        }
        
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Email address cannot be empty."
            return false
        }
        
        guard email.contains("@") && email.contains(".") else {
            errorMessage = "Please enter a valid email address."
            return false
        }
        
        guard !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Password cannot be empty."
            return false
        }
        
        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters long."
            return false
        }
        
        return true
    }
}
