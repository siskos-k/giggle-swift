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
        
        //Reset notifications
        DispatchQueue.main.async {
            self.notifications = []
        }
        
        //Fetch notifications
        fetchSelectedAsWorkerNotifications(for: currentUserId)
        fetchNewApplicantNotificationsAcrossUsers(for: currentUserId)
    }

    private func fetchSelectedAsWorkerNotifications(for userId: String) {
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
                user.reference.collection("gigs").getDocuments { gigsSnapshot, error in
                    if let error = error {
                        print("Error fetching gigs for user: \(user.documentID): \(error.localizedDescription)")
                        return
                    }

                    guard let gigs = gigsSnapshot?.documents else {
                        print("No gigs found for user: \(user.documentID)")
                        return
                    }

                    for gig in gigs {
                        let data = gig.data()

              
                        guard
                            let title = data["title"] as? String,
                            let employerId = data["employerId"] as? String,
                            let workerId = data["workerId"] as? String,
                            workerId == userId,
                            let date = data["date"] as? TimeInterval
                        else {
                            continue
                        }

                        let message = "You have been selected as a worker for the gig: \(title)"
                        let notification = NotificationItem(
                            id: gig.documentID,
                            title: "Selected for a Gig",
                            message: message,
                            date: Date(timeIntervalSince1970: date),
                            gigId: gig.documentID,
                            employerId: employerId
                        )

                        // Append notification on the main thread
                        DispatchQueue.main.async {
                            self.notifications.append(notification)
                        }
                    }
                }
            }
        }
    }

    private func fetchNewApplicantNotificationsAcrossUsers(for currentUserId: String) {
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
                user.reference.collection("gigs").getDocuments { gigsSnapshot, error in
                    if let error = error {
                        print("Error fetching gigs for user: \(user.documentID): \(error.localizedDescription)")
                        return
                    }

                    guard let gigs = gigsSnapshot?.documents else {
                        print("No gigs found for user: \(user.documentID)")
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

                            let message = "\(applicantName) has applied to your gig: \(title)"
                            let notification = NotificationItem(
                                id: UUID().uuidString, // Generate a unique ID for this notification
                                title: "New Applicant",
                                message: message,
                                date: Date(timeIntervalSince1970: date),
                                gigId: gig.documentID,
                                employerId: user.documentID
                            )

                            // Append notification on the main thread
                            DispatchQueue.main.async {
                                self.notifications.append(notification)
                            }
                        }
                    }
                }
            }
        }
    }
}