//
//  HeaderView.swift
//  Giggle
//
//  Created by Konstantinos Siskos on 21/12/24.
//

import SwiftUI

struct HeaderView: View {
    let Title: String = "Giggle"
    let Subtitle: String = "Find quick gigs, get paid instantly."
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .foregroundColor(Color.green)
            VStack {
                Image(.giggleLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 130)
                Text(Title)
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(Color.black) // Correct placement of .foregroundColor
                Text(Subtitle)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color.black) // Correct placement of .foregroundColor
            }
            .frame(width: UIScreen.main.bounds.width, height: 300)
        }
    }
}

#Preview {
    HeaderView()
}
