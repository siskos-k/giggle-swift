//
//  Gig.swift
//  Giggle
//
//  Created by Konstantinos Siskos on 21/12/24.
//

import Foundation

struct Gig: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let category: String
    let location: String
    let isRemote: Bool
    let payment: Int
    let date: TimeInterval
    let createdDate: TimeInterval
    var isDone: Bool
    var applicants: [User] //holding applicants
    var workerId: String? //selected worker from applicants

    mutating func setDone(_ state: Bool) {
        isDone = state
    }

    mutating func addApplicant(_ user: User) {
        applicants.append(user)
    }

    mutating func removeApplicant(byId userId: String) {
        applicants.removeAll { $0.id == userId }
    }
    
    mutating func setWorker(byId userId: String){
        if applicants.contains(where: { $0.id == userId }) {
            workerId = userId
              } else {
                  print("Error: User with ID \(userId) is not an applicant for this gig.")
              }
        }
    }

