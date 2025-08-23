//
//  MainView.swift
//  PokeCodex
//
//  Created by Muhammad Rydwan on 24/08/25.
//

import SwiftUI
import PagerTabStripView

struct MainView: View {
    
    @EnvironmentObject private var navigationManager: NavigationManager
    @State private var selectedTab = 1
    @State private var swipeGestureEnabled: Bool = true
    
    @MainActor var body: some View {
        PagerTabStripView(swipeGestureEnabled: $swipeGestureEnabled, selection: $selectedTab) {
            HomeView(pokemonUseCase: DependencyContainer.shared.pokemonUseCase)
                .pagerTabItem(tag: 1) {
                    VStack {
                        Image(systemName: "house.fill")
                            .font(.title2)
                        Text("Home")
                            .font(.caption)
                    }
                }
            ProfileView()
                .pagerTabItem(tag: 2) {
                    VStack {
                        Image(systemName: "person.fill")
                            .font(.title2)
                        Text("Profile")
                            .font(.caption)
                    }
                }
        }

        .pagerTabStripViewStyle(.barButton())

    }

}


#Preview {
    MainView()
}
