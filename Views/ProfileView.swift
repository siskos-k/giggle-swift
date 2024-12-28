//
//  ProfileView.swift
//  Giggle
//
//  Created by Konstantinos Siskos on 21/12/24.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if let user = viewModel.user {
                    
                    // Avatar with a subtle shadow and circular styling
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.blue)
                        .frame(width: 125, height: 125)
                        .shadow(color: .gray.opacity(0.3), radius: 10, x: 0, y: 5)
                        .padding(.top, 40)
                    
                    // User Info Card
                    VStack(alignment: .leading, spacing: 15) {
                        ProfileInfoRow(title: "Name", value: user.name)
                        ProfileInfoRow(title: "Email", value: user.email)
                        ProfileInfoRow(
                            title: "Member Since",
                            value: "\(Date(timeIntervalSince1970: user.joined).formatted(date: .abbreviated, time: .omitted))"
                        )
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
                    .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 3)
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Log Out Button
                    Button(action: {
                        viewModel.logOut()
                    }) {
                        Text("Log Out")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                } else {
                    // Loading Indicator
                    ProgressView("Loading Profile...")
                        .padding()
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.fetchUser()
            }
        }
    }
}

// Reusable Info Row Component
struct ProfileInfoRow: View {
    var title: String
    var value: String

    var body: some View {
        HStack {
            Text("\(title):")
                .font(.headline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.body)
        }
        .padding(.horizontal)
    }
}

#Preview {
    ProfileView()
}
