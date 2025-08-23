import Foundation
import SwiftUI

enum AppRoute: Hashable, Equatable {
    case login
    case register
    case home
    case pokemonDetail(PokemonListItem)
    case searchPokemon(String)
    
    static func == (lhs: AppRoute, rhs: AppRoute) -> Bool {
        switch (lhs, rhs) {
        case (.login, .login),
             (.register, .register),
             (.home, .home):
            return true
        case (.pokemonDetail(let lhsPokemon), .pokemonDetail(let rhsPokemon)):
            return lhsPokemon.id == rhsPokemon.id
        case (.searchPokemon(let lhsTerm), .searchPokemon(let rhsTerm)):
            return lhsTerm == rhsTerm
        default:
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .login:
            hasher.combine(0)
        case .register:
            hasher.combine(1)
        case .home:
            hasher.combine(2)
        case .pokemonDetail(let pokemon):
            hasher.combine(3)
            hasher.combine(pokemon.id)
        case .searchPokemon(let term):
            hasher.combine(4)
            hasher.combine(term)
        }
    }
}

class NavigationManager: ObservableObject {
    @Published var path: [AppRoute] = []
    @Published var isAuthenticated = false
    
    func navigate(to route: AppRoute) {
        path.append(route)
    }
    
    func replace(with route: AppRoute) {
        path = [route]
    }
    
    func back() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func login() {
        isAuthenticated = true
        path.removeAll()
    }
    
    func logout() {
        isAuthenticated = false
            path.removeAll()
//            path.append(.login)
        
    }
}
