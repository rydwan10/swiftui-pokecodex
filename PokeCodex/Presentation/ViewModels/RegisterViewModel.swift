import Foundation
import RxSwift
import RxCocoa

class RegisterViewModel: ObservableObject {
    private let userUseCase: UserUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var isRegistrationSuccessful = false
    
    let registerSubject = PublishSubject<Void>()
    
    init(userUseCase: UserUseCaseProtocol) {
        self.userUseCase = userUseCase
        setupBindings()
    }
    
    private func setupBindings() {
        registerSubject
            .subscribe(onNext: { [weak self] in
                self?.performRegistration()
            })
            .disposed(by: disposeBag)
    }
    
    private func performRegistration() {
        guard !username.isEmpty && !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty else {
            errorMessage = "Please fill in all fields"
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }
        
        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters"
            return
        }
        
        isLoading = true
        errorMessage = ""
        
        // Check if user already exists
        Observable.combineLatest(
            userUseCase.checkUserExists(email: email),
            userUseCase.checkUsernameExists(username: username)
        )
        .flatMap { [weak self] emailExists, usernameExists -> Observable<Bool> in
            guard let self = self else { return Observable.just(false) }
            
            if emailExists {
                throw NSError(domain: "Registration", code: 1, userInfo: [NSLocalizedDescriptionKey: "Email already exists"])
            }
            
            if usernameExists {
                throw NSError(domain: "Registration", code: 2, userInfo: [NSLocalizedDescriptionKey: "Username already exists"])
            }
            
            return self.userUseCase.registerUser(username: self.username, email: self.email, password: self.password)
        }
        .observe(on: MainScheduler.instance)
        .subscribe(onNext: { [weak self] success in
            self?.isLoading = false
            if success {
                self?.isRegistrationSuccessful = true
            } else {
                self?.errorMessage = "Registration failed"
            }
        }, onError: { [weak self] error in
            self?.isLoading = false
            self?.errorMessage = error.localizedDescription
        })
        .disposed(by: disposeBag)
    }
    
    // MARK: - Database Availability Checking
    
    func checkUsernameAvailability(username: String, completion: @escaping (Bool) -> Void) {
        userUseCase.checkUsernameExists(username: username)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { exists in
                completion(!exists) // Return true if username is available (doesn't exist)
            }, onError: { _ in
                completion(true) // Assume available on error
            })
            .disposed(by: disposeBag)
    }
    
    func checkEmailAvailability(email: String, completion: @escaping (Bool) -> Void) {
        userUseCase.checkUserExists(email: email)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { exists in
                completion(!exists) // Return true if email is available (doesn't exist)
            }, onError: { _ in
                completion(true) // Assume available on error
            })
            .disposed(by: disposeBag)
    }
}
