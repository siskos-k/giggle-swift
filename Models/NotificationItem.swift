//
//  File.swift
//  Giggle
//
//  Created by Konstantinos Siskos on 28/12/24.
//

import Foundation

struct NotificationItem: Identifiable {
    let id: String
    let title: String
    let message: String
    let date: Date
    let gigId: String
    let employerId: String
}
