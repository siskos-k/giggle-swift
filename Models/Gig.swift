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
//    let imageUrl: String?
    var isDone: Bool
    
    mutating func setDone(_ state: Bool) {
        isDone = state
    }
}


