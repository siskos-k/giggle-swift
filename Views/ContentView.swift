//
//  ContentView.swift
//  Giggle
//
//  Created by Konstantinos Siskos on 20/12/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
        TabView{
            GigListView(userId: viewModel.currentUserId)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            MyGigsView(userId: viewModel.currentUserId)
                .tabItem {
                    Label("My Gigs", systemImage: "calendar.and.person")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
            }
        }
        else{
            LoginView()
        }
        
    }
}

#Preview {
    ContentView()
}
