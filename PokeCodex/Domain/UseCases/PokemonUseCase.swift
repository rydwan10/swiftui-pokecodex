import Foundation
import RxSwift

protocol PokemonUseCaseProtocol {
    func getPokemonList(offset: Int, limit: Int) -> Observable<PokemonListResponse>
    func getPokemonDetail(name: String) -> Observable<Pokemon>
    func searchPokemon(name: String) -> Observable<Pokemon>
}

class PokemonUseCase: PokemonUseCaseProtocol {
    private let repository: PokemonRepositoryProtocol
    
    init(repository: PokemonRepositoryProtocol) {
        self.repository = repository
    }
    
    func getPokemonList(offset: Int, limit: Int) -> Observable<PokemonListResponse> {
        return repository.getPokemonList(offset: offset, limit: limit)
    }
    
    func getPokemonDetail(name: String) -> Observable<Pokemon> {
        return repository.getPokemonDetail(name: name)
    }
    
    func searchPokemon(name: String) -> Observable<Pokemon> {
        return repository.searchPokemon(name: name)
    }
}
