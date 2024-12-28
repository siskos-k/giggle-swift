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
            checkIfApplied()
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

        // Fetch the user's name from Firestore
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(currentUserId)

        userRef.getDocument { document, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                self.isLoading = false
                return
            }

            guard let document = document, document.exists,
                  let userData = document.data(),
                  let currentUserName = userData["name"] as? String,
                  let currentUserEmail = userData["email"] as? String else {
                print("Error: User data is incomplete or missing.")
                self.isLoading = false
                return
            }

            let applicantData: [String: Any] = [
                "id": currentUserId,
                "name": currentUserName,
                "email": currentUserEmail,
                "joined": Date().timeIntervalSince1970
            ]

            let gigRef = db.collection("users").document(self.item.employerId).collection("gigs").document(self.item.id)

            gigRef.updateData([
                "applicants": FieldValue.arrayUnion([applicantData])
            ]) { error in
                self.isLoading = false

                if let error = error {
                    print("Error applying to gig: \(error.localizedDescription)")
                    return
                }

                print("Successfully applied to gig.")
                withAnimation {
                    self.hasApplied = true
                }
            }
        }
    }

    private func checkIfApplied() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }

        //check for real time reload
        let db = Firestore.firestore()
        let gigRef = db.collection("users").document(item.employerId).collection("gigs").document(item.id)

        gigRef.getDocument { document, error in
            if let error = error {
                print("Error fetching gig data: \(error.localizedDescription)")
                return
            }

            guard let document = document, let data = document.data(),
                  let applicants = data["applicants"] as? [[String: Any]] else {
                print("Error: Gig data or applicants are missing.")
                return
            }

            hasApplied = applicants.contains { applicant in
                (applicant["id"] as? String) == currentUserId
            }
        }
    }
}
