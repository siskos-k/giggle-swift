//
//  NewGigView.swift
//  Giggle
//
//  Created by Konstantinos Siskos on 21/12/24.
//

import SwiftUI

struct NewGigView: View {
    
    @StateObject var viewModel = NewGigViewModel()
    let categories = ["Hospitality", "Academic", "Art", "Social Media", "Technology", "Other"]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 1)
                .frame(width: 100, height: 100)
                .foregroundColor(Color.green)
            VStack {
                Spacer()
                Text("Provide details about the gig you're offering. Fill out the form below to make your gig appealing and clear for potential applicants.")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                
                Form {
                    TextField("Title", text: $viewModel.title)
                        .padding(.vertical, 8)
                    
                    TextField("Description (1-2 sentences)", text: $viewModel.description)
                        .padding(.vertical, 8)
                    
                    Picker("Category", selection: $viewModel.category) {
                        ForEach(categories, id: \.self) { category in
                            Text(category)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(.vertical, 8)
                    
                    TextField("Location", text: $viewModel.location)
                        .padding(.vertical, 8)
                    
                    Toggle("Remote Work", isOn: $viewModel.isRemote)
                        .padding(.vertical, 8)
                    
                    HStack {
                        Text("Payment")
                        TextField("Enter payment", text: Binding(
                            get: {
                                viewModel.payment == 0 ? "" : String(viewModel.payment)
                            },
                            set: { newValue in
                                if let intValue = Int(newValue) {
                                    viewModel.payment = intValue
                                } else {
                                    viewModel.payment = 0
                                }
                            }
                        ))
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .padding(.vertical, 8)
                    }
                    
                    DatePicker("Date", selection: $viewModel.date)
                        .padding(.vertical, 8)
                    
                    Button(action: {
                        //add uploading method
                    }) {
                        Text("Upload Gig")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.vertical, 8)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
        }
    }
}

#Preview {
    NewGigView()
}
