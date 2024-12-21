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
        NavigationView{
            VStack{
                
            }
            .navigationTitle("Profile")

        }
    }
}

#Preview {
    ProfileView()
}
