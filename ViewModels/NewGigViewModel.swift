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
    init(){}
    
    func save(){}
}
