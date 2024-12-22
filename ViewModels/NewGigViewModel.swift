//
//  NewGigViewModel.swift
//  Giggle
//
//  Created by Konstantinos Siskos on 21/12/24.
//

import Foundation

class NewGigViewModel: ObservableObject{
    @Published var title = ""
    @Published var description = ""
    @Published var date = Date()
    @Published var payment = Int()
    @Published var isRemote: Bool = false
    @Published var location: String = ""
    @Published var category: String = ""
    
    @Published var showAlert: Bool = false
    
    init(){}
    
    func save(){}
    
    var canSave: Bool {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else{
            return false
        }
        //remove seconds of day to take timezones into account.
        guard date >= Date().addingTimeInterval(-86400) else{
           return false
        }
        return true
    }
}
