//
//  GigListView.swift
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
    init(userId: String){
        self.userId = userId
        self._items = FirestoreQuery(collectionPath: "users/\(userId)/gigs")
    }

    var body: some View {
        NavigationView{
            VStack{
                List(items) {
                    item in MyGigView(item: item)
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("My Gigs")
            .toolbar{
                Button {
                    viewModel.showingNewGigView = true
                } label:{Image(systemName: "plus")}
            }
            .sheet(isPresented: $viewModel.showingNewGigView){
                NewGigView( newGigPresented: $viewModel.showingNewGigView)
            }
        }
        
       
    }
}

#Preview {
    MyGigsView(userId: "YK9NDZrChuYf0OVapLZyj2ZbkN83")
}
