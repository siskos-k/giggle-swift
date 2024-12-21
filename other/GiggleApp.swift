//
//  GiggleApp.swift
//  Giggle
//
//  Created by Konstantinos Siskos on 20/12/24.
//

import SwiftUI
import FirebaseCore

@main
struct GiggleApp: App {
    init(){
    FirebaseApp.configure();
}
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
