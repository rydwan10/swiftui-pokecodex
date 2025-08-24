import Foundation
import RxSwift
import RxCocoa
import RxRelay

// MARK: - ViewModel Implementation
final class RegisterViewModel: ObservableObject {
    
    // MARK: - Dependencies
    private let userUseCase: UserUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    // MARK: - Input (User Actions) - Still using BehaviorRelay for RxSwift compatibility
    let username = BehaviorRelay<String>(value: "")
    let email = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")
    let confirmPassword = BehaviorRelay<String>(value: "")
    let registerTapped = PublishRelay<Void>()
    
    // MARK: - Output (UI State) - Using @Published for SwiftUI
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var isRegistrationSuccessful = false
    
    // MARK: - Validation State - Using @Published for SwiftUI
    @Published var usernameError = ""
    @Published var emailError = ""
    @Published var passwordError = ""
    @Published var confirmPasswordError = ""
    
    
    // MARK: - Computed Properties
    var isFormValid: Bool {
        usernameError.isEmpty && 
        emailError.isEmpty && 
        passwordError.isEmpty && 
        confirmPasswordError.isEmpty
    }
    
    // MARK: - Initialization
    init(userUseCase: UserUseCaseProtocol) {
        self.userUseCase = userUseCase
        setupBindings()
    }
    
    // MARK: - Private Methods
    
    private func setupBindings() {
        setupValidationBindings()
        setupRegistrationBinding()
    }
    
    private func setupValidationBindings() {
        // Username validation with debounce and database check
        username
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .flatMapLatest { [weak self] value -> Observable<String> in
                guard let self = self else { return .just("") }
                
                // First check basic validation
                let basicError = self.validateUsername(value)
                if !basicError.isEmpty {
                    return .just(basicError)
                }
                
                // Then check database availability
                return self.userUseCase.checkUsernameExists(username: value)
                    .map { exists in
                        exists ? "Username is already taken" : ""
                    }
                    .catch { _ in
                        .just("") // Assume available on error
                    }
            }
            .subscribe(onNext: { [weak self] error in
                self?.usernameError = error
            })
            .disposed(by: disposeBag)
        
        // Email validation with debounce and database check
        email
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .flatMapLatest { [weak self] value -> Observable<String> in
                guard let self = self else { return .just("") }
                
                // First check basic validation
                let basicError = self.validateEmail(value)
                if !basicError.isEmpty {
                    return .just(basicError)
                }
                
                // Then check database availability
                return self.userUseCase.checkUserExists(email: value)
                    .map { exists in
                        exists ? "Email is already registered" : ""
                    }
                    .catch { _ in
                        .just("") // Assume available on error
                    }
            }
            .subscribe(onNext: { [weak self] error in
                self?.emailError = error
            })
            .disposed(by: disposeBag)
        
        // Password validation
        password
            .map { [weak self] value in
                self?.validatePassword(value) ?? ""
            }
            .subscribe(onNext: { [weak self] error in
                self?.passwordError = error
            })
            .disposed(by: disposeBag)
        
        // Confirm password validation
        Observable.combineLatest(password, confirmPassword)
            .map { [weak self] password, confirmPassword in
                self?.validateConfirmPassword(password, confirmPassword) ?? ""
            }
            .subscribe(onNext: { [weak self] error in
                self?.confirmPasswordError = error
            })
            .disposed(by: disposeBag)
    }
    
    private func setupRegistrationBinding() {
        registerTapped
            .filter { [weak self] _ in
                self?.isFormValid == true
            }
            .subscribe(onNext: { [weak self] _ in
                self?.performRegistration()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Validation Logic
    
    private func validateUsername(_ username: String) -> String {
        let trimmed = username.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmed.isEmpty {
            return "Username is required"
        } else if trimmed.count < 3 {
            return "Username must be at least 3 characters"
        } else if trimmed.count > 20 {
            return "Username must be less than 20 characters"
        }
        return ""
    }
    
    private func validateEmail(_ email: String) -> String {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmed.isEmpty {
            return "Email is required"
        } else if !isValidEmailFormat(trimmed) {
            return "Please enter a valid email address"
        }
        return ""
    }
    
    private func validatePassword(_ password: String) -> String {
        let trimmed = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmed.isEmpty {
            return "Password is required"
        } else if trimmed.count < 6 {
            return "Password must be at least 6 characters"
        } else if trimmed.count > 50 {
            return "Password must be less than 50 characters"
        }
        return ""
    }
    
    private func validateConfirmPassword(_ password: String, _ confirmPassword: String) -> String {
        let trimmedConfirm = confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedConfirm.isEmpty {
            return "Please confirm your password"
        } else if password != confirmPassword {
            return "Passwords do not match"
        }
        return ""
    }
    
    private func isValidEmailFormat(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    // MARK: - Business Logic
    
    private func performRegistration() {
        let usernameValue = username.value.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailValue = email.value.trimmingCharacters(in: .whitespacesAndNewlines)
        let passwordValue = password.value.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Reset state
        isLoading = true
        errorMessage = ""
        isRegistrationSuccessful = false
        
        // Perform registration
        Observable.combineLatest(
            userUseCase.checkUserExists(email: emailValue),
            userUseCase.checkUsernameExists(username: usernameValue)
        )
        .flatMapLatest { [weak self] emailExists, usernameExists -> Observable<Bool> in
            guard let self = self else { return .just(false) }
            
            if emailExists {
                return .error(RegistrationError.emailAlreadyExists)
            }
            if usernameExists {
                return .error(RegistrationError.usernameAlreadyExists)
            }
            
            return self.userUseCase.registerUser(username: usernameValue, email: emailValue, password: passwordValue)
        }
        .observe(on: MainScheduler.instance)
        .subscribe(
            onNext: { [weak self] success in
                self?.handleRegistrationSuccess(success)
            },
            onError: { [weak self] error in
                self?.handleRegistrationError(error)
            }
        )
        .disposed(by: disposeBag)
    }
    
    private func handleRegistrationSuccess(_ success: Bool) {
        isLoading = false
        if success {
            isRegistrationSuccessful = true
            errorMessage = ""
        } else {
            errorMessage = "Registration failed. Please try again."
            isRegistrationSuccessful = false
        }
    }
    
    private func handleRegistrationError(_ error: Error) {
        isLoading = false
        isRegistrationSuccessful = false
        
        if let registrationError = error as? RegistrationError {
            errorMessage = registrationError.localizedDescription
        } else {
            errorMessage = "Registration failed: \(error.localizedDescription)"
        }
    }
}

// MARK: - Custom Errors
enum RegistrationError: LocalizedError {
    case emailAlreadyExists
    case usernameAlreadyExists
    
    var errorDescription: String? {
        switch self {
        case .emailAlreadyExists:
            return "Email is already registered"
        case .usernameAlreadyExists:
            return "Username is already taken"
        }
    }
}
