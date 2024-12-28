//
//  NotificationsViewModel.swift
//  Giggle
//
//  Created by Konstantinos Siskos on 28/12/24.
//
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

        // Fetch notifications
        fetchAcceptedNotifications(for: currentUserId)
        fetchApplicationNotifications(for: currentUserId)
    }
    private func fetchAcceptedNotifications(for currentUserId: String) {
        db.collection("users").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching users: \(error.localizedDescription)")
                return
            }

            guard let users = snapshot?.documents else {
                print("No users found.")
                return
            }

            for user in users {
                // Query gigs where workerId matches currentUserId
                user.reference.collection("gigs")
                    .whereField("workerId", isEqualTo: currentUserId)
                    .getDocuments { gigsSnapshot, error in
                        if let error = error {
                            print("Error fetching gigs for user: \(user.documentID): \(error.localizedDescription)")
                            return
                        }

                        guard let gigs = gigsSnapshot?.documents, !gigs.isEmpty else {
                            print("No gigs found for worker \(currentUserId) in user \(user.documentID).")
                            return
                        }

                        for gig in gigs {
                            let data = gig.data()

                            // Safely parse gig fields
                            guard
                                let title = data["title"] as? String,
                                let date = data["date"] as? TimeInterval,
                                let employerId = data["employerId"] as? String,
                                let employerEmail = user.data()["email"] as? String // Use user's email as fallback
                            else {
                                print("Missing required fields in gig \(gig.documentID). Data: \(data)")
                                continue
                            }

                            let message = "You have been selected as a worker for the gig: **\(title)**! Contact the employer at \(employerEmail)."
                            let notification = NotificationItem(
                                id: gig.documentID,
                                title: "Accepted for Gig",
                                message: message,
                                date: Date(timeIntervalSince1970: date),
                                gigId: gig.documentID,
                                employerId: employerId,
                                isHidden: false
                            )

                            // Append notification on the main thread
                            DispatchQueue.main.async {
                                self.notifications.append(notification)
                                print("Notification added for accepted gig: \(notification)")
                            }
                        }
                    }
            }
        }
    }

    private func fetchApplicationNotifications(for currentUserId: String) {
        db.collection("users")
            .document(currentUserId)
            .collection("gigs")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching gigs for current user: \(error.localizedDescription)")
                    return
                }

                guard let gigs = snapshot?.documents else {
                    print("No gigs found for current user.")
                    return
                }

                for gig in gigs {
                    let data = gig.data()

                    // Safely parse gig fields
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

                        let message = "**\(applicantName)** has applied to your gig: **\(title)**."
                        let notification = NotificationItem(
                            id: UUID().uuidString,
                            title: "New Application - \(title)",
                            message: message,
                            date: Date(timeIntervalSince1970: date),
                            gigId: gig.documentID,
                            employerId: currentUserId,
                            isHidden: false
                        )

                        // Append notification on the main thread
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
