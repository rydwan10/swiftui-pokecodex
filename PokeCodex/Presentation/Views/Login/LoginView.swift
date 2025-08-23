//
//  LoginView.swift
//  PokeCodex
//
//  Created by Muhammad Rydwan on 24/08/25.
//

import SwiftUI
import MBProgressHUD
import RxSwift
import Foundation

struct LoginView: View {
    // MARK: - Properties
    
    @StateObject private var viewModel: LoginViewModel
    @EnvironmentObject private var navigationManager: NavigationManager
    @State private var showRegister = false
    @State private var showToastLoading = false

    private let container = DependencyContainer.shared
    
    // MARK: - Initialization
    
    init(userUseCase: UserUseCaseProtocol) {
        self._viewModel = StateObject(wrappedValue: LoginViewModel(userUseCase: userUseCase))
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 40) {
                    logoAndTitleSection
                    loginFormSection
                }
                .padding(.bottom, 40)
            }
            .background(Color(.systemBackground))
        }
        .sheet(isPresented: $showRegister) {
            RegisterView(userUseCase: container.userUseCase)
        }
        // .onChange(of: viewModel.isLoginSuccessful) { oldValue, newValue in
        //     DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        //         hideLoadingToast()
        //         if newValue == true {
        //         navigationManager.login()
        //     }
        //     }
            
        // }
        // .onChange(of: viewModel.isLoading) { oldValue, newValue in
        //     if !newValue {
        //         hideLoadingToast()
        //     }
        // }
       .overlay {
            if showToastLoading {
                MBProgressHUDView(isShowing: $showToastLoading, text: "Logging in...")
            }
        }
    }
    
    // MARK: - View Components
    
    private var logoAndTitleSection: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image("pokecodex")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
            }
            
            VStack(spacing: 12) {
                Text("PokeCodex")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text("Your Pokemon Encyclopedia")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.top, 40)
    }
    
    private var loginFormSection: some View {
        VStack(spacing: 24) {
            usernameField
            passwordField
            errorMessageView
            loginButton
            registerLink
        }
        .padding(.horizontal, 32)
    }
    
    private var usernameField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Username")
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack {
                Image(systemName: "person.fill")
                    .foregroundColor(.secondary)
                    .frame(width: 20)
                
                TextField("Enter your username", text: $viewModel.username)
                    .textFieldStyle(PlainTextFieldStyle())
                    .autocapitalization(.none)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
    
    private var passwordField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Password")
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack {
                Image(systemName: "lock.fill")
                    .foregroundColor(.secondary)
                    .frame(width: 20)
                
                SecureField("Enter your password", text: $viewModel.password)
                    .textFieldStyle(PlainTextFieldStyle())
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
    
    private var errorMessageView: some View {
        Group {
            if !viewModel.errorMessage.isEmpty {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var loginButton: some View {
        Button(action: {
            performLogin()
        }) {
            HStack {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Text("Login")
                        .fontWeight(.semibold)
                        .font(.title3)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(isFormValid ? Color.blue : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(16)
        }
        .disabled(!isFormValid || viewModel.isLoading)
        .animation(.easeInOut(duration: 0.2), value: isFormValid)
    }
    
    private var registerLink: some View {
        HStack {
            Text("Don't have an account?")
                .foregroundColor(.secondary)
            
            Button("Register") {
                showRegister = true
            }
            .foregroundColor(.blue)
            .fontWeight(.semibold)
        }
        .font(.subheadline)
    }
    
    
    // MARK: - Helper Methods
    
    private var isFormValid: Bool {
        let isUsernameValid = !viewModel.username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let isPasswordValid = !viewModel.password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        return isUsernameValid && isPasswordValid
    }
    
    private func performLogin() {
        guard isFormValid else { return }
        
        // Clear any previous error messages
        viewModel.errorMessage = ""
        
        let trimmedUsername = viewModel.username.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = viewModel.password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        viewModel.username = trimmedUsername
        viewModel.password = trimmedPassword

        showLoadingToast()

        viewModel.loginSubject.onNext(())

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            hideLoadingToast()
             if self.viewModel.isLoginSuccessful {
                self.navigationManager.login()
            }
        }
       
    }
    
    // MARK: - Toast Methods
    
    private func showLoadingToast() {
        showToastLoading = true
    }
    
    private func hideLoadingToast() {
        showToastLoading = false
    }
}

#Preview {
    LoginView(userUseCase: MockUserUseCase())
        .environmentObject(NavigationManager())
}

#Preview("MBProgressHUD") {
    MBProgressHUDView(isShowing: .constant(true), text: "Loading...")
        .frame(width: 200, height: 200)
}

struct MBProgressHUDView: UIViewRepresentable {
        @Binding var isShowing: Bool
        var text: String?

        func makeUIView(context: Context) -> UIView {
            let view = UIView()
            return view
        }

        func updateUIView(_ uiView: UIView, context: Context) {
            if isShowing {
                let hud = MBProgressHUD.showAdded(to: uiView, animated: true)
                hud.mode = .indeterminate
                hud.label.text = text
            } else {
                MBProgressHUD.hide(for: uiView, animated: true)
            }
        }
    }