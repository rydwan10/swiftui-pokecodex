import Foundation
import Alamofire
import RxSwift

protocol PokemonAPIServiceProtocol {
    func fetchPokemonList(offset: Int, limit: Int) -> Observable<PokemonListResponse>
    func fetchPokemonDetail(name: String) -> Observable<Pokemon>
    func searchPokemon(name: String) -> Observable<Pokemon>
}

class PokemonAPIService: PokemonAPIServiceProtocol {
    private let baseURL = "https://pokeapi.co/api/v2"
    
    func fetchPokemonList(offset: Int, limit: Int) -> Observable<PokemonListResponse> {
        return Observable.create { observer in
            let url = "\(self.baseURL)/pokemon?offset=\(offset)&limit=\(limit)"
            
            AF.request(url)
                .validate()
                .responseDecodable(of: PokemonListResponse.self) { response in
                    switch response.result {
                    case .success(let pokemonList):
                        observer.onNext(pokemonList)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            
            return Disposables.create()
        }
    }
    
    func fetchPokemonDetail(name: String) -> Observable<Pokemon> {
        return Observable.create { observer in
            let url = "\(self.baseURL)/pokemon/\(name)"
            
            AF.request(url)
                .validate()
                .responseDecodable(of: Pokemon.self) { response in
                    switch response.result {
                    case .success(let pokemon):
                        observer.onNext(pokemon)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            
            return Disposables.create()
        }
    }
    
    func searchPokemon(name: String) -> Observable<Pokemon> {
        return fetchPokemonDetail(name: name.lowercased())
    }
}
