import Foundation
import RxSwift

protocol UserUseCaseProtocol {
    func registerUser(username: String, email: String, password: String) -> Observable<Bool>
    func loginUser(username: String, password: String) -> Observable<User?>
    func getUserByUsername(username: String) -> Observable<User?>
    func checkUserExists(email: String) -> Observable<Bool>
    func checkUsernameExists(username: String) -> Observable<Bool>
}

class UserUseCase: UserUseCaseProtocol {
    private let repository: UserRepositoryProtocol
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    func registerUser(username: String, email: String, password: String) -> Observable<Bool> {
        return repository.registerUser(username: username, email: email, password: password)
    }
    
    func loginUser(username: String, password: String) -> Observable<User?> {
        return repository.loginUser(username: username, password: password)
    }
    
    func checkUserExists(email: String) -> Observable<Bool> {
        return repository.checkUserExists(email: email)
    }
    
    func getUserByUsername(username: String) -> Observable<User?> {
        return repository.getUserByUsername(username: username)
    }
    
    func checkUsernameExists(username: String) -> Observable<Bool> {
        return repository.checkUsernameExists(username: username)
    }
}
