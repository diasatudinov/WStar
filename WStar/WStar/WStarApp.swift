//
//  WStarApp.swift
//  WStar
//
//

import SwiftUI

@main
struct WStarApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            CPRoot()
                .preferredColorScheme(.light)
        }
    }
}
