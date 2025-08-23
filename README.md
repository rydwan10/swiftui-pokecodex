# PokeCodex - Pokemon Application

A SwiftUI-based Pokemon application built with Clean Architecture, featuring user authentication, Pokemon browsing, and search functionality.

## Features

- **User Authentication**: Login and registration with local database storage
- **Pokemon Browsing**: Infinite scroll list of Pokemon with images
- **Search Functionality**: Search for specific Pokemon by name
- **Pokemon Details**: View Pokemon information and abilities
- **User Profile**: Manage user account and settings
- **Clean Architecture**: Proper separation of concerns with MVVM pattern

## Architecture

The application follows Clean Architecture principles:

```
Core/
├── Domain/
│   ├── Entities/          # Data models
│   └── UseCases/          # Business logic
├── Data/
│   ├── DataSources/       # API and local storage
│   └── Repositories/      # Data access layer
├── Presentation/
│   ├── Views/             # SwiftUI views
│   ├── ViewModels/        # MVVM view models
│   └── Navigation/        # Navigation management
└── DI/                    # Dependency injection
```

## Dependencies

The project uses CocoaPods for dependency management:

- **Alamofire**: HTTP networking
- **Kingfisher**: Image loading and caching
- **RxSwift**: Reactive programming
- **MBProgressHUD**: Loading indicators
- **PagerTabStripView**: Tab navigation
- **CouchbaseLiteSwift**: Local database
- **SwiftData**: Offline data management

## Setup Instructions

### 1. Install Dependencies

```bash
pod install
```

### 2. Open Workspace

Open `PokeCodex.xcworkspace` (not the .xcodeproj file)

### 3. Build and Run

Select your target device/simulator and build the project.

## Project Structure

### Core Files

- **ContentView.swift**: Main navigation controller
- **PokeCodexApp.swift**: App entry point with SwiftData configuration
- **NavigationPath.swift**: Global navigation management
- **DependencyContainer.swift**: Dependency injection container

### Views

- **LoginView.swift**: User authentication
- **RegisterView.swift**: User registration
- **HomeView.swift**: Pokemon list with search
- **ProfileView.swift**: User profile management
- **PokemonDetailView.swift**: Pokemon information display
- **LandingView.swift**: Main tab-based interface

### ViewModels

- **LoginViewModel.swift**: Login logic and validation
- **RegisterViewModel.swift**: Registration logic and validation
- **PokemonListViewModel.swift**: Pokemon list management
- **PokemonDetailViewModel.swift**: Pokemon detail management

### Data Layer

- **PokemonAPIService.swift**: PokeAPI integration
- **UserLocalService.swift**: Local database operations
- **PokemonRepository.swift**: Pokemon data access
- **UserRepository.swift**: User data access

## API Integration

The application integrates with the [PokeAPI](https://pokeapi.co/) to fetch Pokemon data:

- Pokemon list with pagination
- Individual Pokemon details
- Search functionality

## Local Database

Uses Couchbase Lite for user authentication and SwiftData for offline Pokemon data caching.

## Navigation

Global navigation is managed through an enum-based system using EnvironmentObject for state management across the app.

## Notes

- The application is designed for iOS 15.0+
- All networking operations use RxSwift for reactive programming
- Images are loaded and cached using Kingfisher
- Loading states are managed with MBProgressHUD
- Tab navigation is implemented with PagerTabStripView

## Troubleshooting

If you encounter build issues:

1. Ensure you're opening the `.xcworkspace` file, not `.xcodeproj`
2. Run `pod install` to ensure all dependencies are properly installed
3. Clean the build folder (Product > Clean Build Folder)
4. Check that all required frameworks are properly linked

## Future Enhancements

- Pokemon favorites system
- Offline Pokemon data caching
- Push notifications for new Pokemon
- Social features (sharing, comments)
- Advanced search filters
- Pokemon battle simulator
