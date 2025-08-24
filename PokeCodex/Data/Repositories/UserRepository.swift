import Foundation
import RxSwift

protocol UserRepositoryProtocol {
    func registerUser(username: String, email: String, password: String) -> Observable<Bool>
    func loginUser(username: String, password: String) -> Observable<User?>
    func getUserByUsername(username: String) -> Observable<User?>
    func checkUserExists(email: String) -> Observable<Bool>
    func checkUsernameExists(username: String) -> Observable<Bool>
}

class UserRepository: UserRepositoryProtocol {
    private let localService: UserLocalServiceProtocol
    
    init(localService: UserLocalServiceProtocol) {
        self.localService = localService
    }
    
    func registerUser(username: String, email: String, password: String) -> Observable<Bool> {
        let user = User(username: username, email: email, password: password)
        return localService.saveUser(user)
    }
    
    func loginUser(username: String, password: String) -> Observable<User?> {
        return localService.validateUser(username: username, password: password)
    }
    
    func getUserByUsername(username: String) -> Observable<User?> {
        return localService.getUserByUsername(username)
    }
    
    func checkUserExists(email: String) -> Observable<Bool> {
        return localService.getUserByEmail(email)
            .map { $0 != nil }
    }
    
    func checkUsernameExists(username: String) -> Observable<Bool> {
        return localService.getUserByUsername(username)
            .map { $0 != nil }
    }
}
