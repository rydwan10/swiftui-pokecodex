//
//  PokemonDetailView.swift
//  PokeCodex
//
//  Created by Muhammad Rydwan on 24/08/25.
//

import SwiftUI
import Kingfisher
import MBProgressHUD
import RxSwift

struct PokemonDetailView: View {
    // MARK: - Properties
    
    @StateObject private var viewModel: PokemonDetailViewModel
    @EnvironmentObject private var navigationManager: NavigationManager
    
    // MARK: - Initialization
    
    init(pokemonUseCase: PokemonUseCaseProtocol, pokemonName: String) {
        self._viewModel = StateObject(wrappedValue: PokemonDetailViewModel(pokemonUseCase: pokemonUseCase, pokemonName: pokemonName))
    }
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                if let pokemon = viewModel.pokemon {
                    heroSection(pokemon)
                    contentSection(pokemon)
                } else if viewModel.isLoading {
                    LoadingViewDetail()
                } else if !viewModel.errorMessage.isEmpty {
                    ErrorView(message: viewModel.errorMessage)
                }
            }
        }
        .navigationTitle("Pokemon Details")
        .navigationBarTitleDisplayMode(.inline)
       
    }
    
    // MARK: - View Components
    
    private func heroSection(_ pokemon: Pokemon) -> some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.1),
                    Color.purple.opacity(0.1)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 300)
            
            VStack(spacing: 20) {
                pokemonImage(pokemon)
                pokemonNameAndID(pokemon)
            }
            .padding(.top, 20)
        }
    }
    
    private func pokemonImage(_ pokemon: Pokemon) -> some View {
        KFImage(URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(pokemon.id).png"))
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 200, height: 200)
            .background(Color.white.opacity(0.9))
            .clipShape(Circle())
            .shadow(color: .black.opacity(0.2), radius: 15, x: 0, y: 8)
    }
    
    private func pokemonNameAndID(_ pokemon: Pokemon) -> some View {
        VStack(spacing: 8) {
            Text(pokemon.name.capitalized)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            Text("#\(String(format: "%03d", pokemon.id))")
                .font(.title2)
                .foregroundColor(.secondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(20)
        }
    }
    
    private func contentSection(_ pokemon: Pokemon) -> some View {
        VStack(spacing: 24) {
            basicInfoCards(pokemon)
            typesSection(pokemon)
            abilitiesSection(pokemon)
            spritesSection(pokemon)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    private func basicInfoCards(_ pokemon: Pokemon) -> some View {
        HStack(spacing: 16) {
            infoCard(title: "Height", value: "\(pokemon.height / 10).\(pokemon.height % 10) m", icon: "ruler")
            infoCard(title: "Weight", value: "\(pokemon.weight / 10).\(pokemon.weight % 10) kg", icon: "scalemass")
        }
    }
    
    private func infoCard(title: String, value: String, icon: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.headline)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    private func typesSection(_ pokemon: Pokemon) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Types", icon: "shield")
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(pokemon.types, id: \.slot) { typeSlot in
                    TypeChip(type: typeSlot.type)
                }
            }
        }
    }
    
    private func abilitiesSection(_ pokemon: Pokemon) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Abilities", icon: "bolt")
            
            VStack(spacing: 12) {
                ForEach(pokemon.abilities, id: \.id) { ability in
                    AbilityRow(ability: ability)
                }
            }
        }
    }
    
    private func spritesSection(_ pokemon: Pokemon) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Sprites", icon: "photo")
            
            if let frontDefault = pokemon.sprites.frontDefault {
                HStack {
                    Text("Front View")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    KFImage(URL(string: frontDefault))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
            }
        }
    }
    
    private func sectionHeader(title: String, icon: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
            
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
        }
    }
}

// MARK: - Supporting Views

struct TypeChip: View {
    let type: PokemonType
    
    var body: some View {
        Text(type.name.capitalized)
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(typeColor)
            .cornerRadius(20)
            .shadow(color: typeColor.opacity(0.3), radius: 4, x: 0, y: 2)
    }
    
    private var typeColor: Color {
        switch type.name.lowercased() {
        case "normal": return .gray
        case "fire": return .red
        case "water": return .blue
        case "electric": return .yellow
        case "grass": return .green
        case "ice": return .cyan
        case "fighting": return .orange
        case "poison": return .purple
        case "ground": return .brown
        case "flying": return .indigo
        case "psychic": return .pink
        case "bug": return .mint
        case "rock": return .brown
        case "ghost": return .purple
        case "dragon": return .indigo
        case "dark": return .black
        case "steel": return .gray
        case "fairy": return .pink
        default: return .gray
        }
    }
}

struct AbilityRow: View {
    let ability: PokemonAbilitySlot
    
    var body: some View {
        HStack(spacing: 16) {
            // Ability icon
            ZStack {
                Circle()
                    .fill(ability.isHidden ? Color.orange.opacity(0.2) : Color.blue.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: ability.isHidden ? "eye.slash.fill" : "bolt.fill")
                    .foregroundColor(ability.isHidden ? .orange : .blue)
                    .font(.system(size: 16, weight: .semibold))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(ability.ability.name.capitalized)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack(spacing: 8) {
                    Text("Slot \(ability.slot)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                    
                    if ability.isHidden {
                        Text("Hidden")
                            .font(.caption)
                            .foregroundColor(.orange)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.orange.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

struct LoadingViewDetail: View {
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(1.5)
            
            Text("Loading Pokemon details...")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 100)
    }
}

struct ErrorView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 60))
                .foregroundColor(.red)
            
            Text("Error")
                .font(.title)
                .fontWeight(.bold)
            
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 100)
    }
}

#Preview {
    NavigationView {
        PokemonDetailView(pokemonUseCase: MockPokemonUseCase(), pokemonName: "bulbasaur")
            .environmentObject(NavigationManager())
    }
}

#Preview("Loading View") {
    LoadingViewDetail()
}

#Preview("Error View") {
    ErrorView(message: "Failed to load Pokemon details. Please try again later.")
}

#Preview("Ability Row") {
    AbilityRow(ability: PokemonAbilitySlot(
        ability: PokemonAbility(name: "overgrow", url: "https://pokeapi.co/api/v2/ability/65/"),
        isHidden: false,
        slot: 1
    ))
    .padding()
}

#Preview("Hidden Ability Row") {
    AbilityRow(ability: PokemonAbilitySlot(
        ability: PokemonAbility(name: "chlorophyll", url: "https://pokeapi.co/api/v2/ability/34/"),
        isHidden: true,
        slot: 2
    ))
    .padding()
}
