//
//  User.swift
//  Giggle
//
//  Created by Konstantinos Siskos on 21/12/24.
//

import Foundation

struct User: Codable {
    let id: String
    let name: String
    let email: String
    let joined: TimeInterval
}

