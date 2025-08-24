import Foundation

class DependencyContainer {
    static let shared = DependencyContainer()
    
    private init() {}
    
    // MARK: - Services
    lazy var pokemonAPIService: PokemonAPIServiceProtocol = {
        return PokemonAPIService()
    }()
    
    lazy var userLocalService: UserLocalServiceProtocol = {
        return UserLocalService()
    }()
    
    // MARK: - Repositories
    lazy var pokemonRepository: PokemonRepositoryProtocol = {
        return PokemonRepository(apiService: pokemonAPIService)
    }()
    
    lazy var userRepository: UserRepositoryProtocol = {
        return UserRepository(localService: userLocalService)
    }()
    
    // MARK: - Use Cases
    lazy var pokemonUseCase: PokemonUseCaseProtocol = {
        return PokemonUseCase(repository: pokemonRepository)
    }()
    
    lazy var userUseCase: UserUseCaseProtocol = {
        return UserUseCase(repository: userRepository)
    }()
    
    // MARK: - View Models
    func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel(userUseCase: userUseCase)
    }
    
    func makeRegisterViewModel() -> RegisterViewModel {
        return RegisterViewModel(userUseCase: userUseCase)
    }
    
    func makePokemonListViewModel() -> PokemonListViewModel {
        return PokemonListViewModel(pokemonUseCase: pokemonUseCase)
    }
    
    func makePokemonDetailViewModel(pokemonName: String) -> PokemonDetailViewModel {
        return PokemonDetailViewModel(pokemonUseCase: pokemonUseCase, pokemonName: pokemonName)
    }
    
    func makeProfileViewModel() -> ProfileViewModel {
        return ProfileViewModel(userUseCase: userUseCase)
    }
}
