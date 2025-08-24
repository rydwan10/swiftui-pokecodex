//
//  RegisterView.swift
//  PokeCodex
//
//  Created by Muhammad Rydwan on 24/08/25.
//

import SwiftUI
import RxSwift
import RxCocoa
import RxRelay

struct RegisterView: View {
    @StateObject private var viewModel: RegisterViewModel
    private let disposeBag = DisposeBag()
    @Environment(\.dismiss) private var dismiss
    
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    init(userUseCase: UserUseCaseProtocol) {
        _viewModel = StateObject(wrappedValue: RegisterViewModel(userUseCase: userUseCase))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // Header Section
                    headerSection
                    
                    // Form Section
                    formSection
                    
                    // Action Buttons
                    actionButtonsSection
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
            }
            .background(Color(.systemBackground))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Back") {
                    dismiss()
                }
                .foregroundColor(.blue)
            )
        }
       
        .onChange(of: username) { _, newValue in
            viewModel.username.accept(newValue)
        }
        .onChange(of: email) { _, newValue in
            viewModel.email.accept(newValue)
        }
        .onChange(of: password) { _, newValue in
            viewModel.password.accept(newValue)
        }
        .onChange(of: confirmPassword) { _, newValue in
            viewModel.confirmPassword.accept(newValue)
        }
    }
    
    // MARK: - Header Section
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
    
    // MARK: - Form Section
    private var formSection: some View {
        VStack(spacing: 20) {
            FormField(
                title: "Username", 
                icon: "person.fill", 
                text: $username, 
                placeholder: "Enter username", 
                validation: { viewModel.usernameError.isEmpty }, 
                errorMessage: viewModel.usernameError
            )
            
            FormField(
                title: "Email", 
                icon: "envelope.fill", 
                text: $email, 
                placeholder: "Enter email", 
                validation: { viewModel.emailError.isEmpty }, 
                errorMessage: viewModel.emailError
            )
            
            FormField(
                title: "Password", 
                icon: "lock.fill", 
                text: $password, 
                placeholder: "Enter password", 
                isSecure: true, 
                validation: { viewModel.passwordError.isEmpty }, 
                errorMessage: viewModel.passwordError
            )
            
            FormField(
                title: "Confirm Password", 
                icon: "lock.shield.fill", 
                text: $confirmPassword, 
                placeholder: "Confirm password", 
                isSecure: true, 
                validation: { viewModel.passwordError.isEmpty }, 
                errorMessage: viewModel.confirmPasswordError
            )
            
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
    
    // MARK: - Action Buttons Section
    private var actionButtonsSection: some View {
        VStack(spacing: 16) {
            // Register Button
            Button(action: {
                // Update ViewModel with current form values
                viewModel.username.accept(username)
                viewModel.email.accept(email)
                viewModel.password.accept(password)
                viewModel.confirmPassword.accept(confirmPassword)
                
                // Trigger registration
                viewModel.registerTapped.accept(())
                dismiss()
            }) {
                HStack {
                    if viewModel.isLoading {
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
                .background(viewModel.isFormValid ? Color.green : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(16)
            }
            .disabled(!viewModel.isFormValid || viewModel.isLoading)
            .animation(.easeInOut(duration: 0.2), value: viewModel.isFormValid)
            
            // Login Link
            HStack {
                Text("Already have an account?")
                    .foregroundColor(.secondary)
                
                Button("Login") {
                    dismiss()
                }
                .foregroundColor(.blue)
                .fontWeight(.semibold)
            }
            .font(.subheadline)
        }
        .padding(.top, 20)
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
