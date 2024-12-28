import SwiftUI

struct NotificationsView: View {
    @StateObject var viewModel = NotificationsViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.notifications.filter({ !$0.isHidden }).isEmpty {
                    Text("No notifications yet.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        // Group notifications by day
                        ForEach(groupNotificationsByDay(viewModel.notifications.filter({ !$0.isHidden })), id: \.key) { day, notifications in
                            Section(header: Text(day)) {
                                ForEach(notifications) { notification in
                                    NotificationRow(notification: notification)
                                        .swipeActions {
                                            Button(role: .destructive) {
                                                viewModel.hideNotification(id: notification.id)
                                            } label: {
                                                Label("Hide",  systemImage: "trash")
                                            }
                                        }
                                }
                            }
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

    // Helper function to group notifications by day
    private func groupNotificationsByDay(_ notifications: [NotificationItem]) -> [(key: String, value: [NotificationItem])] {
        let grouped = Dictionary(grouping: notifications) { notification in
            notification.date.formatted(.dateTime.day().month().year()) // Group by formatted date
        }
        return grouped.sorted { $0.key > $1.key } // Sort by date (newest first)
    }
}
struct NotificationRow: View {
    let notification: NotificationItem

    var body: some View {
        VStack(alignment: .leading) {
            Text(notification.title)
                .font(.headline)
//                .foregroundColor(.black)

            buildMessage(notification.message) // Properly combine bold and regular parts

            Text(notification.date.formatted(date: .abbreviated, time: .shortened))
                .font(.footnote)
                .foregroundColor(.gray)
        }
    }

    private func buildMessage(_ message: String) -> Text {
        if message.contains("**") {
            let components = message.components(separatedBy: "**")
            return components.enumerated().reduce(Text("")) { result, pair in
                let (index, part) = pair
                if index % 2 == 1 {
                    // Bold parts
                    return result + Text(part).bold().foregroundColor(.gray)
                } else {
                    // Regular parts
                    return result + Text(part).foregroundColor(.gray)
                }
            }
        } else {
            return Text(message).foregroundColor(.gray)
        }
    }
}
