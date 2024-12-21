//
//  GigListView.swift
//  Giggle
//
//  Created by Konstantinos Siskos on 21/12/24.
//

import SwiftUI

struct GigListView: View {
    @StateObject var viewModel = GigListViewModel()
    private let userId: String
    init(userId: String){
        self.userId = userId
    }

    var body: some View {
        NavigationView{
            VStack{
                
            }
            .navigationTitle("Giggle")
            .toolbar{
                Button {
                    viewModel.showingNewGigView = true
                } label:{Image(systemName: "plus")}
            }
            .sheet(isPresented: $viewModel.showingNewGigView){
                NewGigView()
            }
        }
        
       
    }
}

#Preview {
    GigListView(userId: "")
}
