import Foundation
import FirebaseFirestore
import FirebaseAuth

class GigViewModel: ObservableObject {
    @Published var hasApplied: Bool = false // Track if the user has applied

    init() {}

    func applyToGig(_ gig: Gig) {
        guard !hasApplied else { return } // Prevent multiple applications
        hasApplied = true

        // Add the current user to the gig's applicants in the database
        let db = Firestore.firestore()
        guard let userId = Auth.auth().currentUser?.uid else { return }

        db.collection("users")
            .document(gig.id)
            .updateData(["applicants": FieldValue.arrayUnion([userId])]) { error in
                if let error = error {
                    print("Error updating applicants: \(error.localizedDescription)")
                    self.hasApplied = false // Reset state if there's an error
                }
            }
    }

    func checkIfApplied(_ gig: Gig) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        hasApplied = gig.applicants.contains { $0.id == userId }
    }
}

