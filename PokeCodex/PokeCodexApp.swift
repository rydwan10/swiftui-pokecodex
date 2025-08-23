//
//  PokeCodexApp.swift
//  PokeCodex
//
//  Created by Muhammad Rydwan on 23/08/25.
//

import SwiftUI

@main
struct PokeCodexApp: App {
     @StateObject private var navigationManager = NavigationManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
            .environmentObject(navigationManager)
        }
    }
}
