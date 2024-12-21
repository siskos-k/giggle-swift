//
//  TLButton.swift
//  Giggle
//
//  Created by Konstantinos Siskos on 21/12/24.
//

import SwiftUI

struct GButton: View {
    let title: String = "Log In"
    let background: Color = Color.blue
    
    var body: some View {
        Button(action: {
            // Add login action
        }) {
            Text("Log In")
                .bold()
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(8)
    }
   
    
}

#Preview {
    GButton()
}
