//
//  MockData.swift
//  PokeCodex
//
//  Created by Muhammad Rydwan on 24/08/25.
//

import Foundation
import RxSwift
import SwiftUI

// MARK: - Mock Pokemon Use Case for Preview

public class MockPokemonUseCase: PokemonUseCaseProtocol {
    func getPokemonList(offset: Int, limit: Int) -> Observable<PokemonListResponse> {
        let mockPokemon = [
            PokemonListItem(id: 1, name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"),
            PokemonListItem(id: 2, name: "ivysaur", url: "https://pokeapi.co/api/v2/pokemon/2/"),
            PokemonListItem(id: 3, name: "venusaur", url: "https://pokeapi.co/api/v2/pokemon/3/")
        ]
        let response = PokemonListResponse(count: 151, next: nil, previous: nil, results: mockPokemon)
        return Observable.just(response)
    }
    
    func getPokemonDetail(name: String) -> Observable<Pokemon> {
        let mockPokemon = Pokemon(
            id: 1,
            name: "bulbasaur",
            height: 7,
            weight: 69,
            sprites: Sprites(frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png"),
            types: [PokemonTypeSlot(slot: 1, type: PokemonType(name: "grass", url: "https://pokeapi.co/api/v2/ability/12/"))],
            abilities: [PokemonAbilitySlot(ability: PokemonAbility(name: "overgrow", url: "https://pokeapi.co/api/v2/ability/65/"), isHidden: false, slot: 1)]
        )
        return Observable.just(mockPokemon)
    }
    
    func searchPokemon(name: String) -> Observable<Pokemon> {
        return getPokemonDetail(name: name)
    }
}

// MARK: - Mock User Use Case for Preview

public class MockUserUseCase: UserUseCaseProtocol {
    func registerUser(username: String, email: String, password: String) -> Observable<Bool> {
        // Simulate successful registration for preview
        return Observable.just(true)
    }
    
    func loginUser(username: String, password: String) -> Observable<User?> {
        // Simulate successful login for preview
        let mockUser = User(username: "preview_user", email: "preview@example.com", password: "password123")
        return Observable.just(mockUser)
    }
    
    func checkUserExists(email: String) -> Observable<Bool> {
        // Simulate user check for preview
        return Observable.just(false)
    }
    
    func checkUsernameExists(username: String) -> Observable<Bool> {
        // Simulate username check for preview
        return Observable.just(false)
    }
}
