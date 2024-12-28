//
//  GigListView.swift
//  Giggle
//
//  Created by Konstantinos Siskos on 21/12/24.
//

import SwiftUI
import FirebaseFirestore

struct GigListView: View {
    @StateObject var viewModel = GigListViewModel()
    @State private var gigs: [Gig] = []
    @State private var filteredGigs: [Gig] = []
    @State private var isLoading: Bool = true
    @State private var selectedCategory: String? = nil

    private let userId: String
    private let categories = ["Hospitality", "Academic", "Art", "Social Media", "Technology", "Other"]

    init(userId: String) {
        self.userId = userId
    }

    var body: some View {
        NavigationView {
            VStack {
                // Filter Buttons
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(categories, id: \.self) { category in
                            Button(action: {
                                withAnimation {
                                    if selectedCategory == category {
                                        selectedCategory = nil // Deselect category
                                    } else {
                                        selectedCategory = category // Select new category
                                    }
                                    filterGigs()
                                }
                            }) {
                                HStack {
                                    Image(systemName: icon(for: category))
                                        .resizable()
                                        .frame(width: 16, height: 16)
                                        .foregroundColor(selectedCategory == category ? .white : .blue)
                                    Text(category)
                                        .font(.subheadline)
                                        .foregroundColor(selectedCategory == category ? .white : .blue)
                                }
                                .padding(8)
                                .background(selectedCategory == category ? Color.blue : Color.gray.opacity(0.2))
                                .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                if isLoading {
                    Text("Gigs Loading...")
                        .foregroundColor(.gray)
                        .padding()
                } else if filteredGigs.isEmpty {
                    Text("No gigs available in this category.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(filteredGigs) { item in
                        GigView(item: item)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Giggle")
            .sheet(isPresented: $viewModel.showingNewGigView) {
                NewGigView(newGigPresented: $viewModel.showingNewGigView)
            }
            .onAppear(perform: fetchGigs)
        }
    }

    private func fetchGigs() {
        isLoading = true
        let db = Firestore.firestore()
        db.collection("users")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching user IDs: \(error.localizedDescription)")
                    isLoading = false
                    return
                }

                let userIDs = snapshot?.documents.compactMap { $0.documentID } ?? []
                let filteredUserIDs = userIDs.filter { $0 != userId }

                var allGigs: [Gig] = []
                let group = DispatchGroup()

                for id in filteredUserIDs {
                    group.enter()
                    db.collection("users/\(id)/gigs")
                        .getDocuments { gigSnapshot, gigError in
                            if let gigError = gigError {
                                print("Error fetching gigs for user \(id): \(gigError.localizedDescription)")
                            } else {
                                let userGigs = gigSnapshot?.documents.compactMap {
                                    try? $0.data(as: Gig.self)
                                } ?? []
                                allGigs.append(contentsOf: userGigs)
                            }
                            group.leave()
                        }
                }

                group.notify(queue: .main) {
                    self.gigs = allGigs
                    self.filteredGigs = allGigs
                    self.isLoading = false
                }
            }
    }

    private func filterGigs() {
        if let selectedCategory = selectedCategory {
            filteredGigs = gigs.filter { $0.category == selectedCategory }
        } else {
            filteredGigs = gigs // Show all gigs when no category is selected
        }
    }

    private func icon(for category: String) -> String {
        switch category {
        case "Hospitality": return "fork.knife"
        case "Academic": return "book"
        case "Art": return "paintbrush"
        case "Social Media": return "message"
        case "Technology": return "desktopcomputer"
        case "Other": return "questionmark"
        default: return "questionmark"
        }
    }
}

#Preview {
    GigListView(userId: "cPoiKNpzBvOhQumkpa5Zfuqdw9W2")
}
