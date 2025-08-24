//
//  ProfileView.swift
//  PokeCodex
//
//  Created by Muhammad Rydwan on 24/08/25.
//

import SwiftUI
import MBProgressHUD
import RxSwift

struct ProfileView: View {
    // MARK: - Properties
    
    @EnvironmentObject private var navigationManager: NavigationManager
    @StateObject private var viewModel: ProfileViewModel
    
    // MARK: - Initialization
    
    init() {
        self._viewModel = StateObject(wrappedValue: DependencyContainer.shared.makeProfileViewModel())
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            VStack {
                profileHeader
                profileOptions
                Spacer()
                logoutButton
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            viewModel.loadCurrentUser()
        }
    }
    
    // MARK: - View Components
    
    private var profileHeader: some View {
        VStack(spacing: 20) {
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .frame(height: 100)
            } else {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.blue)
            }
            
            VStack(spacing: 8) {
                if viewModel.isLoading {
                    Text("Loading...")
                        .font(.title)
                        .foregroundColor(.secondary)
                } else {
                    Text(viewModel.currentUser?.username ?? "User")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(viewModel.currentUser?.email ?? "email@example.com")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Member since \(viewModel.currentUser?.createdAt.formatted(date: .abbreviated, time: .omitted) ?? "Unknown")")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
    }
    
    private var profileOptions: some View {
        VStack(spacing: 0) {
            ProfileOptionRow(
                icon: "person.fill",
                title: "Edit Profile",
                action: {
                    // TODO: Implement edit profile
                }
            )
            
            ProfileOptionRow(
                icon: "gear",
                title: "Settings",
                action: {
                    // TODO: Implement settings
                }
            )
            
            ProfileOptionRow(
                icon: "questionmark.circle",
                title: "Help & Support",
                action: {
                    // TODO: Implement help
                }
            )
            
            ProfileOptionRow(
                icon: "info.circle",
                title: "About",
                action: {
                    // TODO: Implement about
                }
            )
        }
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    private var logoutButton: some View {
        Button(action: {
            viewModel.clearCurrentUser()
            navigationManager.logout()
        }) {
            HStack {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                Text("Logout")
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.red)
            .cornerRadius(25)
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
    
    // MARK: - Helper Methods
    
    // Profile data is now managed by ProfileViewModel
}

// MARK: - Profile Option Row

struct ProfileOptionRow: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .frame(width: 24)
                
                Text(title)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .buttonStyle(PlainButtonStyle())
        
        if title != "About" {
            Divider()
                .padding(.leading, 56)
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(NavigationManager())
}

#Preview("Profile Option Row") {
    ProfileOptionRow(
        icon: "person.fill",
        title: "Edit Profile",
        action: {}
    )
    .padding()
}

#Preview("Profile Option Row with Divider") {
    VStack(spacing: 0) {
        ProfileOptionRow(
            icon: "gear",
            title: "Settings",
            action: {}
        )
        ProfileOptionRow(
            icon: "questionmark.circle",
            title: "Help & Support",
            action: {}
        )
    }
    .background(Color(.systemGray6))
    .cornerRadius(12)
    .padding()
}
