//
//  RegisterView.swift
//  PokeCodex
//
//  Created by Muhammad Rydwan on 24/08/25.
//

import SwiftUI
import RxSwift

struct RegisterView: View {
    // MARK: - Properties
    
    @StateObject private var viewModel: RegisterViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isLoading = false
    @State private var errorMessage = ""
    @State private var isFormValid = false
    @State private var showLoadingHUD = false
    
    @State private var usernameError = ""
    @State private var emailError = ""
    @State private var passwordError = ""
    @State private var confirmPasswordError = ""
    
    // MARK: - Initialization
    
    init(userUseCase: UserUseCaseProtocol) {
        self._viewModel = StateObject(wrappedValue: RegisterViewModel(userUseCase: userUseCase))
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    headerSection
                    formSection
                }
                .padding(.bottom, 40)
            }
            .background(Color(.systemBackground))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.blue)
            )
        }
        .onChange(of: viewModel.isLoading) { loading in
            isLoading = loading
            if loading {
                showLoadingHUDFunc()
            } else {
                hideLoadingHUDFunc()
            }
        }
        .onChange(of: viewModel.errorMessage) { message in
            errorMessage = message
            if !message.isEmpty {
                hideLoadingHUDFunc()
            }
        }
        .onChange(of: viewModel.isRegistrationSuccessful) { success in
            if success {
                hideLoadingHUDFunc()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .onChange(of: username) { newValue in 
            if !usernameError.isEmpty {
                usernameError = ""
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if newValue == username {
                    validateForm()
                }
            }
        }
        .onChange(of: email) { newValue in 
            if !emailError.isEmpty {
                emailError = ""
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if newValue == email {
                    validateForm()
                }
            }
        }
        .onChange(of: password) { newValue in 
            if !passwordError.isEmpty {
                passwordError = ""
            }
            if !confirmPasswordError.isEmpty && newValue == confirmPassword {
                confirmPasswordError = ""
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if newValue == password {
                    validateForm()
                }
            }
        }
        .onChange(of: confirmPassword) { newValue in 
            if !confirmPasswordError.isEmpty {
                confirmPasswordError = ""
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if newValue == confirmPassword {
                    validateForm()
                }
            }
        }
    }
    
    // MARK: - View Components
    
    private var headerSection: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.1))
                    .frame(width: 100, height: 100)
                
                Image(systemName: "person.badge.plus")
                    .font(.system(size: 50))
                    .foregroundColor(.green)
            }
            
            VStack(spacing: 8) {
                Text("Create Account")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Join PokeCodex today!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.top, 20)
    }
    
    private var formSection: some View {
        VStack(spacing: 20) {
            FormField(
                title: "Username",
                icon: "person.fill",
                text: $username,
                placeholder: "Enter username",
                validation: { isUsernameFieldValid },
                errorMessage: usernameError
            )
            
            FormField(
                title: "Email",
                icon: "envelope.fill",
                text: $email,
                placeholder: "Enter your email",
                validation: { isEmailFieldValid },
                errorMessage: emailError
            )
            
            FormField(
                title: "Password",
                icon: "lock.fill",
                text: $password,
                placeholder: "Enter password",
                isSecure: true,
                validation: { isPasswordFieldValid },
                errorMessage: passwordError
            )
            
            FormField(
                title: "Confirm Password",
                icon: "lock.shield.fill",
                text: $confirmPassword,
                placeholder: "Confirm password",
                isSecure: true,
                validation: { isConfirmPasswordFieldValid },
                errorMessage: confirmPasswordError
            )
            
            errorMessageView
            registerButton
            loginLink
        }
        .padding(.horizontal, 32)
    }
    
    private var errorMessageView: some View {
        Group {
            if !errorMessage.isEmpty {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var registerButton: some View {
        Button(action: {
            performRegistration()
        }) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Text("Create Account")
                        .fontWeight(.semibold)
                        .font(.title3)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(isFormValid ? Color.green : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(16)
        }
        .disabled(!isFormValid || isLoading)
        .animation(.easeInOut(duration: 0.2), value: isFormValid)
    }
    
    private var loginLink: some View {
        HStack {
            Text("Already have an account?")
                .foregroundColor(.secondary)
            
            Button("Login") {
                presentationMode.wrappedValue.dismiss()
            }
            .foregroundColor(.blue)
            .fontWeight(.semibold)
        }
        .font(.subheadline)
    }
    
    // MARK: - Validation Methods
    
    private var isUsernameFieldValid: Bool {
        !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && usernameError.isEmpty
    }
    
    private var isEmailFieldValid: Bool {
        isValidEmail(email) && emailError.isEmpty
    }
    
    private var isPasswordFieldValid: Bool {
        password.count >= 6 && passwordError.isEmpty
    }
    
    private var isConfirmPasswordFieldValid: Bool {
        password == confirmPassword && !confirmPassword.isEmpty && confirmPasswordError.isEmpty
    }
    
    // MARK: - Form Validation
    
    private func validateForm() {
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedConfirmPassword = confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines)
        
        validateUsername(trimmedUsername)
        validateEmail(trimmedEmail)
        validatePassword(trimmedPassword)
        validateConfirmPassword(trimmedPassword, trimmedConfirmPassword)
        
        checkDatabaseAvailability()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            isFormValid = usernameError.isEmpty && 
                         emailError.isEmpty && 
                         passwordError.isEmpty && 
                         confirmPasswordError.isEmpty &&
                         !trimmedUsername.isEmpty &&
                         !trimmedEmail.isEmpty &&
                         !trimmedPassword.isEmpty &&
                         !trimmedConfirmPassword.isEmpty
        }
    }
    
    private func validateUsername(_ username: String) {
        if username.isEmpty {
            usernameError = "Username is required"
        } else if username.count < 3 {
            usernameError = "Username must be at least 3 characters"
        } else if username.count > 20 {
            usernameError = "Username must be less than 20 characters"
        } else {
            usernameError = ""
        }
    }
    
    private func validateEmail(_ email: String) {
        if email.isEmpty {
            emailError = "Email is required"
        } else if !isValidEmail(email) {
            emailError = "Please enter a valid email address"
        } else {
            emailError = ""
        }
    }
    
    private func validatePassword(_ password: String) {
        if password.isEmpty {
            passwordError = "Password is required"
        } else if password.count < 6 {
            passwordError = "Password must be at least 6 characters"
        } else if password.count > 50 {
            passwordError = "Password must be less than 50 characters"
        } else {
            passwordError = ""
        }
    }
    
    private func validateConfirmPassword(_ password: String, _ confirmPassword: String) {
        if confirmPassword.isEmpty {
            confirmPasswordError = "Please confirm your password"
        } else if password != confirmPassword {
            confirmPasswordError = "Passwords do not match"
        } else {
            confirmPasswordError = ""
        }
    }
    
    // MARK: - Database Operations
    
    private func checkDatabaseAvailability() {
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !trimmedUsername.isEmpty && usernameError.isEmpty {
            viewModel.checkUsernameAvailability(username: trimmedUsername) { isAvailable in
                DispatchQueue.main.async {
                    if !isAvailable {
                        usernameError = "Username is already taken"
                    }
                }
            }
        }
        
        if !trimmedEmail.isEmpty && emailError.isEmpty {
            viewModel.checkEmailAvailability(email: trimmedEmail) { isAvailable in
                DispatchQueue.main.async {
                    if !isAvailable {
                        emailError = "Email is already registered"
                    }
                }
            }
        }
    }
    
    // MARK: - Utility Methods
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func performRegistration() {
        guard isFormValid else { return }
        
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        viewModel.username = trimmedUsername
        viewModel.email = trimmedEmail
        viewModel.password = trimmedPassword
        viewModel.confirmPassword = trimmedPassword
        
        showLoadingHUD = true
        viewModel.registerSubject.onNext(())
    }
    
    private func showLoadingHUDFunc() {
        showLoadingHUD = true
    }
    
    private func hideLoadingHUDFunc() {
        showLoadingHUD = false
    }
}

// MARK: - Supporting Views

struct FormField: View {
    let title: String
    let icon: String
    @Binding var text: String
    let placeholder: String
    var isSecure: Bool = false
    let validation: () -> Bool
    let errorMessage: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.secondary)
                    .frame(width: 20)
                
                if isSecure {
                    SecureField(placeholder, text: $text)
                        .textFieldStyle(PlainTextFieldStyle())
                } else {
                    TextField(placeholder, text: $text)
                        .textFieldStyle(PlainTextFieldStyle())
                        .autocapitalization(.none)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(text.isEmpty ? Color.clear : (validation() ? Color.green : Color.red), lineWidth: 1)
            )
            
            if !errorMessage.isEmpty {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.red)
                        .font(.system(size: 12))
                    
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .lineLimit(2)
                }
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.2), value: errorMessage)
            }
        }
    }
}

#Preview {
    RegisterView(userUseCase: MockUserUseCase())
}

#Preview("Form Field") {
    FormField(
        title: "Username",
        icon: "person.fill",
        text: .constant("testuser"),
        placeholder: "Enter username",
        validation: { true },
        errorMessage: ""
    )
    .padding()
}

#Preview("Form Field with Error") {
    FormField(
        title: "Email",
        icon: "envelope.fill",
        text: .constant("invalid-email"),
        placeholder: "Enter email",
        validation: { false },
        errorMessage: "Please enter a valid email address"
    )
    .padding()
}
