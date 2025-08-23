import Foundation
import RxSwift
import RxCocoa

class PokemonDetailViewModel: ObservableObject {
    private let pokemonUseCase: PokemonUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    @Published var pokemon: Pokemon?
    @Published var isLoading = false
    @Published var errorMessage = ""
    
    init(pokemonUseCase: PokemonUseCaseProtocol, pokemonName: String) {
        self.pokemonUseCase = pokemonUseCase
        loadPokemonDetail(name: pokemonName)
    }
    
    private func loadPokemonDetail(name: String) {
        print("🔄 Loading Pokemon detail for: \(name)")
        isLoading = true
        errorMessage = ""
        
        pokemonUseCase.getPokemonDetail(name: name)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] pokemon in
                print("✅ Pokemon detail loaded successfully: \(pokemon.name) (ID: \(pokemon.id))")
                self?.isLoading = false
                self?.pokemon = pokemon
            }, onError: { [weak self] error in
                print("❌ Failed to load Pokemon details for \(name): \(error.localizedDescription)")
                self?.isLoading = false
                self?.errorMessage = "Failed to load Pokemon details: \(error.localizedDescription)"
            })
            .disposed(by: disposeBag)
    }
}
