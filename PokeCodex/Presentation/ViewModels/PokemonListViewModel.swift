import Foundation
import RxSwift
import RxCocoa

class PokemonListViewModel: ObservableObject {
    private let pokemonUseCase: PokemonUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    @Published var pokemonList: [PokemonListItem] = []
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var hasMoreData = true
    
    private var currentOffset = 0
    private let limit = 20
    
    let loadMoreSubject = PublishSubject<Void>()
    let searchSubject = PublishSubject<String>()
    
    init(pokemonUseCase: PokemonUseCaseProtocol) {
        self.pokemonUseCase = pokemonUseCase
        setupBindings()
        loadPokemonList()
    }
    
    private func setupBindings() {
        loadMoreSubject
            .subscribe(onNext: { [weak self] in
                self?.loadMorePokemon()
            })
            .disposed(by: disposeBag)
        
        searchSubject
            .subscribe(onNext: { [weak self] searchTerm in
                self?.searchPokemon(searchTerm)
            })
            .disposed(by: disposeBag)
    }
    
    func loadPokemonList() {
        print("🔄 Loading Pokemon list...")
        isLoading = true
        errorMessage = ""
        
        pokemonUseCase.getPokemonList(offset: currentOffset, limit: limit)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                print("✅ Pokemon list loaded successfully: \(response.results.count) Pokemon")
                self?.isLoading = false
                self?.pokemonList = response.results
                self?.hasMoreData = response.next != nil
                self?.currentOffset = self?.pokemonList.count ?? 0
            }, onError: { [weak self] error in
                print("❌ Failed to load Pokemon: \(error.localizedDescription)")
                self?.isLoading = false
                self?.errorMessage = "Failed to load Pokemon: \(error.localizedDescription)"
            })
            .disposed(by: disposeBag)
    }
    
    func refreshPokemonList() {
        print("🔄 Refreshing Pokemon list...")
        currentOffset = 0
        pokemonList = []
        hasMoreData = true
        loadPokemonList()
    }
    
    private func loadMorePokemon() {
        guard !isLoading && hasMoreData else { return }
        
        isLoading = true
        
        pokemonUseCase.getPokemonList(offset: currentOffset, limit: limit)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                self?.isLoading = false
                self?.pokemonList.append(contentsOf: response.results)
                self?.hasMoreData = response.next != nil
                self?.currentOffset = self?.pokemonList.count ?? 0
            }, onError: { [weak self] error in
                self?.isLoading = false
                self?.errorMessage = "Failed to load more Pokemon: \(error.localizedDescription)"
            })
            .disposed(by: disposeBag)
    }
    
    private func searchPokemon(_ searchTerm: String) {
        guard !searchTerm.isEmpty else {
            loadPokemonList()
            return
        }
        
        isLoading = true
        errorMessage = ""
        
        pokemonUseCase.searchPokemon(name: searchTerm)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] pokemon in
                self?.isLoading = false
                let searchResult = PokemonListItem(id: pokemon.id, name: pokemon.name, url: "")
                self?.pokemonList = [searchResult]
                self?.hasMoreData = false
            }, onError: { [weak self] error in
                self?.isLoading = false
                self?.errorMessage = "Pokemon not found"
                self?.pokemonList = []
            })
            .disposed(by: disposeBag)
    }
}
