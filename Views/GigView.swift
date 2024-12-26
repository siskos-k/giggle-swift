//
//  GigView.swift
//  Giggle
//
//  Created by Konstantinos Siskos on 21/12/24.
//
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct GigView: View {
    let item: Gig
    @State private var hasApplied: Bool = false
    @State private var isLoading: Bool = false

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(item.title)
                        .font(.headline)
                        .foregroundColor(.black)

                    HStack(spacing: 4) {
                        Image(systemName: "location")
                            .resizable()
                            .frame(width: 14, height: 14)
                            .foregroundColor(.blue)
                        Text(item.isRemote ? "Remote" : item.location)
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }

                    Text(item.description)
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                    Text(Date(timeIntervalSince1970: item.date).formatted(date: .abbreviated, time: .omitted))
                        .font(.footnote)
                        .foregroundColor(.black)
                }

                Spacer()

                Text("\(item.payment)€")
                    .font(.title3)
                    .foregroundColor(.green)
                    .bold()
            }
            Divider()
            Button(action: {
                withAnimation {
                    isLoading = true
                    applyToGig()
                }
            }) {
                HStack {
                    if isLoading {
                        ProgressView()
                    } else {
                        Image(systemName: "briefcase")
                        Text(hasApplied ? "Already Applied" : "Apply")
                            .font(.subheadline)
                    }
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(hasApplied ? Color.gray : Color.blue)
                .cornerRadius(8)
            }
            .disabled(hasApplied || isLoading)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .onAppear {
            if Auth.auth().currentUser == nil {
                print("No authenticated user.")
                // Handle unauthenticated user (e.g., redirect to login)
            } else {
                checkIfApplied()
            }
        }
    }

    private func applyToGig() {
        guard !hasApplied else {
            print("User has already applied.")
            return
        }
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("Error: User is not authenticated.")
            isLoading = false
            return
        }

        let currentUserName = Auth.auth().currentUser?.displayName ?? "Anonymous"
        let currentUserEmail = Auth.auth().currentUser?.email ?? "no-email@example.com"

        print("User ID: \(currentUserId), Name: \(currentUserName), Email: \(currentUserEmail)")

        let applicantData: [String: Any] = [
            "id": currentUserId,
            "name": currentUserName,
            "email": currentUserEmail,
            "joined": Date().timeIntervalSince1970
        ]

        let db = Firestore.firestore()
        let gigRef = db.collection("users").document(item.employerId).collection("gigs").document(item.id)

        print("Firestore Path: \(gigRef.path)")

        gigRef.updateData([
            "applicants": FieldValue.arrayUnion([applicantData])
        ]) { error in
            isLoading = false

            if let error = error {
                print("Error applying to gig: \(error.localizedDescription)")
                return
            }

            print("Successfully applied to gig.")
            withAnimation {
                hasApplied = true
            }
        }
    }

    private func checkIfApplied() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        hasApplied = item.applicants.contains { $0.id == currentUserId }
    }
}
