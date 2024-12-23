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
    
    private let userId: String
    init(userId: String) {
        self.userId = userId
    }

    var body: some View {
        NavigationView {
            VStack {
                if gigs.isEmpty {
                    Text("No gigs available.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(gigs) { item in
                        GigView(item: item)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Giggle")
            .toolbar {
                Button {
                    viewModel.showingNewGigView = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $viewModel.showingNewGigView) {
                NewGigView(newGigPresented: $viewModel.showingNewGigView)
            }
            .onAppear(perform: fetchGigs)
        }
    }
    
    private func fetchGigs() {
        let db = Firestore.firestore()
        db.collection("users")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching user IDs: \(error.localizedDescription)")
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
                }
            }
    }
}

#Preview {
    GigListView(userId: "cPoiKNpzBvOhQumkpa5Zfuqdw9W2")
}
