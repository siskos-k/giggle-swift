//
//  MyGigsView.swift
//  Giggle
//
//  Created by Konstantinos Siskos on 21/12/24.
//

import SwiftUI
import FirebaseFirestore

struct MyGigsView: View {
    @StateObject var viewModel = GigListViewModel()
    @FirestoreQuery var items: [Gig]

    private let userId: String

    init(userId: String) {
        self.userId = userId
        self._items = FirestoreQuery(collectionPath: "users/\(userId)/gigs")
    }

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(items) { item in
                        MyGigView(item: item)
                            .padding(.horizontal)
                            .padding(.top, 8)
                            .background(Color.white.opacity(0))
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                    }
                }
                .padding(.top, 16)
            }
            .background(Color(UIColor.systemGroupedBackground)) // Optional background
            .navigationTitle("My Gigs")
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
        }
    }
}



#Preview {
    MyGigsView(userId: "YK9NDZrChuYf0OVapLZyj2ZbkN83")
}
