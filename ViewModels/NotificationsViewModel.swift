import Foundation
import FirebaseFirestore
import FirebaseAuth

class NotificationsViewModel: ObservableObject {
    @Published var notifications: [NotificationItem] = []

    private let db = Firestore.firestore()

    func fetchNotifications() {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("Error: No authenticated user.")
            return
        }
        
        // Reset notifications
        DispatchQueue.main.async {
            self.notifications = []
        }
        
        // Fetch relevant notifications
        fetchSelectedAsWorkerNotifications(for: currentUserId)
        fetchNewApplicantNotifications(for: currentUserId)
    }

    private func fetchSelectedAsWorkerNotifications(for userId: String) {
        db.collection("users").document(userId).collection("gigs")
            .whereField("workerId", isEqualTo: userId)
            .getDocuments { gigsSnapshot, error in
                if let error = error {
                    print("Error fetching gigs for worker: \(error.localizedDescription)")
                    return
                }

                guard let gigs = gigsSnapshot?.documents else {
                    print("No gigs found for worker.")
                    return
                }

                for gig in gigs {
                    let data = gig.data()
                    guard
                        let title = data["title"] as? String,
                        let employerEmail = data["employerEmail"] as? String,
                        let date = data["date"] as? TimeInterval
                    else {
                        continue
                    }

                    let message = "You have been selected as a worker for the gig: **\(title)**! Contact the employer at \(employerEmail)."
                    let notification = NotificationItem(
                        id: gig.documentID,
                        title: "You've been selected!",
                        message: message,
                        date: Date(timeIntervalSince1970: date),
                        gigId: gig.documentID,
                        employerId: userId,
                        isHidden: false
                    )

                    DispatchQueue.main.async {
                        self.notifications.append(notification)
                    }
                }
            }
    }

    private func fetchNewApplicantNotifications(for userId: String) {
        db.collection("users").document(userId).collection("gigs")
            .getDocuments { gigsSnapshot, error in
                if let error = error {
                    print("Error fetching gigs for employer: \(error.localizedDescription)")
                    return
                }

                guard let gigs = gigsSnapshot?.documents else {
                    print("No gigs found for employer.")
                    return
                }

                for gig in gigs {
                    let data = gig.data()
                    guard
                        let title = data["title"] as? String,
                        let applicants = data["applicants"] as? [[String: Any]],
                        let date = data["date"] as? TimeInterval
                    else {
                        continue
                    }

                    for applicant in applicants {
                        guard let applicantName = applicant["name"] as? String else {
                            continue
                        }

                        let message = "**\(applicantName)** has applied to your gig: **\(title)**. Go to 'My Gigs' to view their application."
                        let notification = NotificationItem(
                            id: UUID().uuidString,
                            title: "New Applicant - \(title)",
                            message: message,
                            date: Date(timeIntervalSince1970: date),
                            gigId: gig.documentID,
                            employerId: userId,
                            isHidden: false
                        )

                        DispatchQueue.main.async {
                            self.notifications.append(notification)
                        }
                    }
                }
            }
    }

    func hideNotification(id: String) {
        DispatchQueue.main.async {
            if let index = self.notifications.firstIndex(where: { $0.id == id }) {
                self.notifications[index].isHidden = true
            }
        }
    }
}
