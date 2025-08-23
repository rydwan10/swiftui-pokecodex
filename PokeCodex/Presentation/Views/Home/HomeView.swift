//
//  HomeView.swift
//  PokeCodex
//
//  Created by Muhammad Rydwan on 24/08/25.
//

import SwiftUI
import Kingfisher
import MBProgressHUD
import RxSwift

struct HomeView: View {
    // MARK: - Properties
    
    @StateObject private var viewModel: PokemonListViewModel
    @EnvironmentObject private var navigationManager: NavigationManager
    @State private var searchText = ""
    @State private var showSearch = false
    
    // MARK: - Initialization
    
    init(pokemonUseCase: PokemonUseCaseProtocol) {
        self._viewModel = StateObject(wrappedValue: PokemonListViewModel(pokemonUseCase: pokemonUseCase))
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        navigationManager.logout()
                    }) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.red)
                            .font(.system(size: 20))
                    }
                    .padding(.horizontal)
                }
                searchBar
                pokemonListContent
            }
            .navigationTitle("Pokemon")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            if viewModel.pokemonList.isEmpty && !viewModel.isLoading {
                viewModel.loadPokemonList()
            }
        }
    }
    
    // MARK: - View Components
    
    private var searchBar: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search Pokemon...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                        viewModel.searchSubject.onNext("")
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            Button(action: {
                if !searchText.isEmpty {
                    viewModel.searchSubject.onNext(searchText)
                }
            }) {
                Text("Search")
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
        .padding(.horizontal)
        .padding(.top)
    }
    
    private var pokemonListContent: some View {
        Group {
            if viewModel.pokemonList.isEmpty && !viewModel.isLoading {
                emptyStateView
            } else {
                pokemonListView
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Pokemon found")
                .font(.title2)
                .foregroundColor(.gray)
            
            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var pokemonListView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.pokemonList) { pokemon in
                        PokemonRowView(pokemon: pokemon)
                            .onTapGesture {
                                navigationManager.navigate(
                                    to: .pokemonDetail(pokemon)
                                )
                            }
                            .onAppear {
                                if pokemon.id == viewModel.pokemonList.last?.id {
                                    viewModel.loadMoreSubject.onNext(())
                                }
                            }
                    }
                    
                    loadingIndicator
                    loadMoreButton
                    endOfListIndicator
                }
            }
            .refreshable {
                viewModel.refreshPokemonList()
            }
        }
    }
    
    private var loadingIndicator: some View {
        Group {
            if viewModel.isLoading && !viewModel.pokemonList.isEmpty {
                HStack {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.2)
                    Spacer()
                }
                .padding(.vertical, 20)
            }
        }
    }
    
    private var loadMoreButton: some View {
        Group {
            if viewModel.hasMoreData && !viewModel.isLoading && !viewModel.pokemonList.isEmpty {
                Button(action: {
                    viewModel.loadMoreSubject.onNext(())
                }) {
                    HStack {
                        Image(systemName: "arrow.down.circle.fill")
                        Text("Load More Pokemon")
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .cornerRadius(25)
                }
                .padding(.vertical, 20)
            }
        }
    }
    
    private var endOfListIndicator: some View {
        Group {
            if !viewModel.hasMoreData && !viewModel.pokemonList.isEmpty {
                HStack {
                    Spacer()
                    VStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.title2)
                        Text("All Pokemon loaded!")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 20)
                    Spacer()
                }
            }
        }
    }
}

// MARK: - Pokemon Row View

struct PokemonRowView: View {
    let pokemon: PokemonListItem
    
    var body: some View {
        HStack(spacing: 15) {
            pokemonImage
            pokemonInfo
            Spacer()
            chevronIndicator
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
    }
    
    private var pokemonImage: some View {
        KFImage(URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(pokemon.id).png"))
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 60, height: 60)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    private var pokemonInfo: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(pokemon.name.capitalized)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("#\(String(format: "%03d", pokemon.id))")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(8)
        }
    }
    
    private var chevronIndicator: some View {
        Image(systemName: "chevron.right")
            .foregroundColor(.secondary)
            .font(.system(size: 14, weight: .medium))
    }
}

#Preview {
    HomeView(pokemonUseCase: MockPokemonUseCase())
        .environmentObject(NavigationManager())
}

#Preview("Pokemon Row") {
    PokemonRowView(pokemon: PokemonListItem(id: 1, name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"))
        .padding()
}
