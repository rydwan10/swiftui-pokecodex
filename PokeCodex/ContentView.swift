//
//  ContentView.swift
//  PokeCodex
//
//  Created by Muhammad Rydwan on 23/08/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            Group {
                // Initial view based on authentication state
                if navigationManager.isAuthenticated {
                    MainView()
                } else {
                    LoginView(userUseCase: DependencyContainer.shared.userUseCase)
                }
            }
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .login:
                    LoginView(userUseCase: DependencyContainer.shared.userUseCase)
                case .register:
                    RegisterView(userUseCase: DependencyContainer.shared.userUseCase)
                case .home:
                    MainView()
                case .pokemonDetail(let pokemon):
                    PokemonDetailView(pokemonUseCase: DependencyContainer.shared.pokemonUseCase, pokemonName: pokemon.name)
                case .searchPokemon(let searchTerm):
                    PokemonDetailView(pokemonUseCase: DependencyContainer.shared.pokemonUseCase, pokemonName: searchTerm)
                }
            }

        }
    }
}

#Preview {
    ContentView()
        .environmentObject(NavigationManager())
}
