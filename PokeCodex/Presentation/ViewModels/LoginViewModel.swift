import Foundation
import RxSwift
import RxCocoa

class LoginViewModel: ObservableObject {
    private let userUseCase: UserUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    @Published var username = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var isLoginSuccessful = false
    
    let loginSubject = PublishSubject<Void>()
    
    init(userUseCase: UserUseCaseProtocol) {
        self.userUseCase = userUseCase
        setupBindings()
    }
    
    private func setupBindings() {
        loginSubject
            .subscribe(onNext: { [weak self] in
                self?.performLogin()
            })
            .disposed(by: disposeBag)
    }
    
    private func performLogin() {
        guard !username.isEmpty && !password.isEmpty else {
            errorMessage = "Please fill in all fields"
            return
        }
        
        isLoading = true
        errorMessage = ""
        
        // Use username for login (assuming the API accepts username)
        userUseCase.loginUser(username: username, password: password)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] user in
                self?.isLoading = false
                if let user = user {
                    // Store username for profile access
                    UserDefaults.standard.set(self?.username, forKey: "currentUsername")
                    self?.isLoginSuccessful = true
                } else {
                    self?.errorMessage = "Invalid username or password"
                }
            }, onError: { [weak self] error in
                self?.isLoading = false
                self?.errorMessage = "Login failed: \(error.localizedDescription)"
            })
            .disposed(by: disposeBag)
    }
}
