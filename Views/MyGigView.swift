//
//  MyGigView.swift
//  Giggle
//
//  Created by Konstantinos Siskos on 21/12/24.
//

import SwiftUI

struct MyGigView: View {
    let item: Gig
    
    @State private var showApplicants: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Main gig details
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    // Title
                    Text(item.title)
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    // Location
                    HStack(spacing: 4) {
                        Image(systemName: "location")
                            .resizable()
                            .frame(width: 14, height: 14)
                            .foregroundColor(.blue)
                        Text(item.isRemote ? "Remote" : item.location)
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                    
                    // Description
                    Text(item.description)
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .lineLimit(2) // Adjust to show limited lines of text
                    Text(Date(timeIntervalSince1970: item.date).formatted(date: .abbreviated, time: .omitted))
                        .font(.footnote)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                // Payment
                Text("\(item.payment)€")
                    .font(.title3)
                    .foregroundColor(.green)
                    .bold()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)

            // Applicant list section
            VStack(alignment: .leading) {
                if item.applicants.isEmpty {
                    Text("There are currently no applicants")
                        .font(.footnote)
                        .foregroundColor(.gray)
                } else {
                    Button(action: {
                        withAnimation {
                            showApplicants.toggle()
                        }
                    }) {
                        HStack {
                            Text("View Applicants")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                            Spacer()
                            Image(systemName: showApplicants ? "chevron.up" : "chevron.down")
                                .foregroundColor(.blue)
                        }
                    }
                    
                    if showApplicants {
                        ForEach(item.applicants, id: \.id) { applicant in
                            VStack(alignment: .leading) {
                                Text(applicant.name)
                                    .font(.footnote)
                                    .foregroundColor(.black)
                                Text(applicant.email)
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 2)
                        }
                    }
                }
            }
            .padding()
        }
        .padding(.horizontal)
    }
}

#Preview {
    MyGigView(item: Gig(
        id: UUID().uuidString,
        title: "This is a gig",
        description: "This is the description. It will take 1-2 or maybe even 3 sentences.",
        category: "Other",
        location: "Moon",
        isRemote: true,
        payment: 123,
        date: Date().timeIntervalSince1970,
        createdDate: Date().timeIntervalSince1970,
        isDone: false,
        applicants: [
//            User(id: UUID().uuidString, name: "Alice", email: "alice@example.com", joined: Date().timeIntervalSince1970),
//            User(id: UUID().uuidString, name: "Bob", email: "bob@example.com", joined: Date().timeIntervalSince1970)
        ],
        workerId: nil
    ))
}
