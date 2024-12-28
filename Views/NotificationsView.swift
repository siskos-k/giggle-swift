//
//  NotificationsView.swift
//  Giggle
//
//  Created by Konstantinos Siskos on 21/12/24.
//
import SwiftUI
import FirebaseFirestore

struct NotificationsView: View {
    @StateObject var viewModel = NotificationsViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.notifications.isEmpty {
                    Text("No notifications yet.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(viewModel.notifications) { notification in
                        VStack(alignment: .leading) {
                            Text(notification.title)
                                .font(.headline)
                                .foregroundColor(.black)
                            Text(notification.message)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(notification.date.formatted(date: .abbreviated, time: .shortened))
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Notifications")
            .onAppear {
                viewModel.fetchNotifications()
            }
        }
    }
}
