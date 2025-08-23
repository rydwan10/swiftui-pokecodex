import Foundation
import RxSwift

protocol PokemonRepositoryProtocol {
    func getPokemonList(offset: Int, limit: Int) -> Observable<PokemonListResponse>
    func getPokemonDetail(name: String) -> Observable<Pokemon>
    func searchPokemon(name: String) -> Observable<Pokemon>
}

class PokemonRepository: PokemonRepositoryProtocol {
    private let apiService: PokemonAPIServiceProtocol
    
    init(apiService: PokemonAPIServiceProtocol) {
        self.apiService = apiService
    }
    
    func getPokemonList(offset: Int, limit: Int) -> Observable<PokemonListResponse> {
        return apiService.fetchPokemonList(offset: offset, limit: limit)
    }
    
    func getPokemonDetail(name: String) -> Observable<Pokemon> {
        return apiService.fetchPokemonDetail(name: name)
    }
    
    func searchPokemon(name: String) -> Observable<Pokemon> {
        return apiService.searchPokemon(name: name)
    }
}
