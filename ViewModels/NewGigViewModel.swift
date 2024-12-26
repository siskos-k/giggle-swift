//
//  NewGigViewModel.swift
//  Giggle
//
//  Created by Konstantinos Siskos on 21/12/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class NewGigViewModel: ObservableObject {
    @Published var title = ""
    @Published var description = ""
    @Published var date = Date()
    @Published var payment = Int()
    @Published var isRemote: Bool = false
    @Published var location: String = ""
    @Published var category: String = ""

    @Published var showAlert: Bool = false
    
    init() {}
    
    func save() {
        guard canSave else {
            return
        }
        // get userId
        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }
        // create model
        let newId = UUID().uuidString
        let newGig = Gig(
            id: newId,
            title: title,
            description: description,
            category: category,
            location: location,
            isRemote: isRemote,
            payment: payment,
            date: date.timeIntervalSince1970,
            createdDate: Date().timeIntervalSince1970,
            isDone: false,
            applicants: [], // Empty applicant list
            workerId: nil   // Nil workerId
        )
        // save model
        let db = Firestore.firestore()
        db.collection("users")
            .document(uId)
            .collection("gigs")
            .document(newId)
            .setData(newGig.asDictionary())
    }
    
    var canSave: Bool {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        guard !description.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        guard !category.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        guard !location.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        guard !(payment == 0) else {
            return false
        }
        // remove seconds of day to take timezones into account.
        guard date >= Date().addingTimeInterval(-86400) else {
            return false
        }
        return true
    }
}
