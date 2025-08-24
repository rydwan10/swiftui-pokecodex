//
//  ProfileViewModel.swift
//  PokeCodex
//
//  Created by Muhammad Rydwan on 24/08/25.
//

import Foundation
import RxSwift
import RxCocoa

class ProfileViewModel: ObservableObject {
    private let userUseCase: UserUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage = ""
    
    init(userUseCase: UserUseCaseProtocol) {
        self.userUseCase = userUseCase
    }
    
    // MARK: - Public Methods
    
    /// Updates the current user when login is successful
    func updateCurrentUser(_ user: User) {
        currentUser = user
    }
    
    /// Loads user data from the database
    func loadCurrentUser() {
        guard let username = getStoredUsername() else {
            // No stored username, show error
            errorMessage = "No user session found"
            return
        }
        
        isLoading = true
        errorMessage = ""
        
        // Directly get user by username from the database
        userUseCase.getUserByUsername(username: username)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] user in
                self?.isLoading = false
                if let user = user {
                    self?.currentUser = user
                } else {
                    self?.errorMessage = "Failed to load user profile"
                }
            }, onError: { [weak self] error in
                self?.isLoading = false
                self?.errorMessage = "Error loading profile: \(error.localizedDescription)"
            })
            .disposed(by: disposeBag)
    }
    
    /// Clears current user data (for logout)
    func clearCurrentUser() {
        currentUser = nil
        clearStoredUsername()
    }
    
    // MARK: - Private Methods
    
    private func getUserByUsername(_ username: String) -> Observable<User?> {
        // Use the real getUserByUsername method from UserUseCase
        return userUseCase.getUserByUsername(username: username)
    }
    
    private func getStoredUsername() -> String? {
        return UserDefaults.standard.string(forKey: "currentUsername")
    }
    
    private func clearStoredUsername() {
        UserDefaults.standard.removeObject(forKey: "currentUsername")
    }
}

// MARK: - User Session Management Extension

extension ProfileViewModel {
    /// Stores username when login is successful
    func storeUsername(_ username: String) {
        UserDefaults.standard.set(username, forKey: "currentUsername")
    }
}
