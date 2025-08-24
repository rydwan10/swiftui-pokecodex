# 🎮 PokeCodex
<img width="128" height="128" alt="pokecodex" src="https://github.com/user-attachments/assets/fa17dce1-ff20-411d-95c7-cc358c96d051" />

A comprehensive iOS Pokemon encyclopedia application built with SwiftUI, featuring user authentication, Pokemon data browsing, and detailed information display.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Dependencies](#dependencies)
- [API Integration](#api-integration)
- [Project Structure](#project-structure)
- [Setup & Installation](#setup--installation)
- [Usage](#usage)
- [Database](#database)
- [Testing](#testing)

## 🚀 Overview

PokeCodex is a modern iOS application that provides users with comprehensive Pokemon information. The app features a clean, intuitive interface built with SwiftUI and follows MVVM architecture patterns. Users can browse Pokemon lists, view detailed information, search for specific Pokemon, and manage their profiles.

## ✨ Features

- **🔐 User Authentication**: Secure login and registration system
- **📱 Pokemon Browsing**: Browse through Pokemon with pagination
- **🔍 Search Functionality**: Search Pokemon by name
- **📖 Detailed Views**: Comprehensive Pokemon information display
- **👤 User Profiles**: Personal user profiles with session management
- **💾 Offline Support**: Local data storage with Couchbase Lite
- **🎨 Modern UI**: SwiftUI-based interface with smooth animations

| Registration  | Main Flow | Infinite Scroll | 
| ------------- | ------------- | ------------ |
| <video src="https://github.com/user-attachments/assets/28dadd0b-f6fe-48a9-b8f3-2d158486b4e9" /> | <video src="https://github.com/user-attachments/assets/7b624639-4f9e-4f69-88f2-482b6eb0b3db" />  |  <video src="https://github.com/user-attachments/assets/f3b8a787-0cc4-44e9-b6c1-f5a24810cead" /> |





## 🏗️ Architecture

The application follows the **Clean Architecture** pattern with **MVVM** presentation layer:

- **🎨 Presentation Layer**: SwiftUI Views and ViewModels
- **🧠 Domain Layer**: Use Cases and Entities
- **💾 Data Layer**: Repositories and Data Sources
- **🔧 Dependency Injection**: Centralized dependency management

## 📦 Dependencies

### Core Dependencies

- **🖥️ SwiftUI**: Modern declarative UI framework
- **⚡ Combine**: Reactive programming framework
- **🔧 Foundation**: Core iOS functionality

### Third-Party Packages

#### RxSwift & RxCocoa
- **Purpose**: Reactive programming and asynchronous operations
- **Usage**: Managing API calls, user authentication, and data binding
- **Key Features**: Observable patterns, error handling, thread management

#### Alamofire
- **Purpose**: HTTP networking library
- **Usage**: API calls to PokeAPI
- **Key Features**: Request/response handling, error management, request chaining

#### Couchbase Lite Swift
- **Purpose**: Local NoSQL database
- **Usage**: User data storage, offline data persistence
- **Key Features**: Document-based storage, querying, sync capabilities

#### Kingfisher
- **Purpose**: Image downloading and caching
- **Usage**: Pokemon sprite and artwork loading
- **Key Features**: Memory/disk caching, placeholder images, image processing

#### MBProgressHUD
- **Purpose**: Loading indicators and progress displays
- **Usage**: Show loading states during API calls
- **Key Features**: Customizable progress indicators, toast messages

#### PagerTabStripView
- **Purpose**: Tab-based navigation
- **Usage**: Main app navigation between Home and Profile
- **Key Features**: Swipe gestures, custom tab styling, smooth transitions

## 🌐 API Integration

### PokeAPI
- **🔗 Base URL**: `https://pokeapi.co/api/v2/`
- **🔓 Authentication**: None required (public API)
- **📡 Endpoints Used**:
  - `GET /pokemon`: Pokemon list with pagination
  - `GET /pokemon/{name}`: Pokemon by name

### API Service Implementation
The `PokemonAPIService` handles all API communications:
- Request/response management
- Error handling and retry logic
- Response caching
- Network status monitoring

## 📁 Project Structure

```
PokeCodex/
├── PokeCodex/                    # Main application source
│   ├── Assets.xcassets/          # App icons and images
│   ├── ContentView.swift         # Root view with navigation
│   ├── PokeCodexApp.swift        # App entry point
│   ├── PokeCodex.entitlements   # App capabilities
│   ├── PokeCodexLaunchScreen.storyboard # Launch screen
│   │
│   ├── Data/                     # Data layer
│   │   ├── DataSources/          # Data source implementations
│   │   │   ├── PokemonAPIService.swift    # PokeAPI integration
│   │   │   └── UserLocalService.swift     # Local database service
│   │   └── Repositories/         # Repository implementations
│   │       ├── PokemonRepository.swift    # Pokemon data repository
│   │       └── UserRepository.swift       # User data repository
│   │
│   ├── DI/                       # Dependency injection
│   │   └── DependencyContainer.swift     # Central dependency management
│   │
│   ├── Domain/                   # Domain layer
│   │   ├── Entities/             # Data models
│   │   │   ├── Pokemon.swift             # Pokemon entity
│   │   │   └── User.swift                # User entity
│   │   └── UseCases/             # Business logic
│   │       ├── PokemonUseCase.swift      # Pokemon operations
│   │       └── UserUseCase.swift         # User operations
│   │
│   ├── Presentation/             # Presentation layer
│   │   ├── Mocks/                # Mock data for previews
│   │   │   └── MockData.swift            # Mock use cases
│   │   ├── Navigation/           # Navigation management
│   │   │   └── NavigationManager.swift   # App navigation state
│   │   ├── ViewModels/           # View models
│   │   │   ├── LoginViewModel.swift      # Login logic
│   │   │   ├── PokemonDetailViewModel.swift # Pokemon detail logic
│   │   │   ├── PokemonListViewModel.swift   # Pokemon list logic
│   │   │   ├── ProfileViewModel.swift       # Profile logic
│   │   │   └── RegisterViewModel.swift     # Registration logic
│   │   └── Views/                # SwiftUI views
│   │       ├── Home/             # Home screen views
│   │       │   └── HomeView.swift         # Main Pokemon list
│   │       ├── Login/            # Authentication views
│   │       │   └── LoginView.swift       # Login screen
│   │       ├── Main/             # Main app views
│   │       │   └── MainView.swift        # Tab-based main view
│   │       ├── PokemonDetail/    # Pokemon detail views
│   │       │   └── PokemonDetailView.swift # Pokemon information
│   │       ├── Profile/          # User profile views
│   │       │   └── ProfileView.swift     # User profile screen
│   │       └── Register/         # Registration views
│   │           └── RegisterView.swift    # User registration
│
├── PokeCodex.xcodeproj/          # Xcode project file
├── PokeCodex.xcworkspace/        # CocoaPods workspace
├── Podfile                       # CocoaPods dependencies
├── Podfile.lock                  # Locked dependency versions
├── PokeCodexTests/               # Unit tests
├── PokeCodexUITests/             # UI tests
├── Pods/                         # CocoaPods dependencies
│   ├── Alamofire/                # HTTP networking
│   ├── CouchbaseLite-Swift/      # Local database
│   ├── Kingfisher/               # Image loading & caching
│   ├── MBProgressHUD/            # Loading indicators
│   ├── RxCocoa/                  # Reactive programming
│   ├── RxRelay/                  # Reactive relays
│   ├── RxSwift/                  # Reactive programming core
│   └── XLPagerTabStrip/          # Tab navigation
└── README.md                     # This file
```

## ⚙️ Setup & Installation

### Prerequisites
- 🖥️ Xcode 15.0+
- 📱 iOS 17.0+
- 📦 CocoaPods

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/PokeCodex.git
   cd PokeCodex
   ```

2. **Install dependencies**
   ```bash
   pod install
   ```

3. **Open workspace**
   ```bash
   open PokeCodex.xcworkspace
   ```

4. **Build and run**
   - Select your target device/simulator
   - Press Cmd+R to build and run

## 📱 Usage

### User Authentication

1. **📝 Registration**: Create a new account with username, email, and password
2. **🔐 Login**: Authenticate with registered credentials
3. **🚪 Logout**: Secure logout with session cleanup

### Pokemon Browsing

1. **🏠 Home Screen**: Browse Pokemon with infinite scrolling
2. **🔍 Search**: Find specific Pokemon by name
3. **📖 Details**: Tap on Pokemon to view comprehensive information
4. **📄 Pagination**: Load more Pokemon as you scroll

### Profile Management

1. **👤 View Profile**: See your account information


## 💾 Database

### Couchbase Lite Integration

The app uses Couchbase Lite for local data storage:

- **🗄️ Database Name**: `pokecodex_users`
- **📚 Collections**: User accounts and preferences
- **📱 Offline Support**: Full functionality without internet connection

### Data Models

#### User Entity
```swift
struct User {
    let id: String
    let username: String
    let email: String
    let password: String
    let createdAt: Date
}
```

#### Pokemon Entity
```swift
struct Pokemon {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let sprites: Sprites
    let types: [PokemonTypeSlot]
    let abilities: [PokemonAbilitySlot]
}
```

## 💻 Development Guidelines

### Code Style
- 📚 Follow Swift API Design Guidelines
- 🏷️ Use meaningful variable and function names
- ⚠️ Implement proper error handling
- 📖 Add comprehensive documentation

### Architecture Principles
- 🎯 Single Responsibility Principle
- 🔄 Dependency Inversion
- 🧹 Clean separation of concerns

### Performance Considerations
- 🖼️ Efficient image caching with Kingfisher
- 📱 Lazy loading for Pokemon lists
- 🔄 Background API calls
- 💾 Memory management with proper disposal

## 🚀 Future Enhancements

- **📱 Offline Mode**: Enhanced offline functionality
- **⭐ Favorites**: Save favorite Pokemon
- **👥 Team Builder**: Create Pokemon teams
- **🌐 Social Features**: Share teams and discoveries
- **🔍 Advanced Search**: Filter by type, abilities, stats
- **🌙 Dark Mode**: Enhanced theme support
- **♿ Accessibility**: VoiceOver and accessibility improvements

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For support and questions:
- 🐛 Create an issue in the GitHub repository
- 📧 Contact the development team
- 📚 Check the documentation and code comments

## 🙏 Acknowledgments

- **🎮 PokeAPI**: Pokemon data and sprites
- **📦 CocoaPods**: Dependency management
- **🖥️ SwiftUI Community**: UI framework and best practices
- **🌟 Open Source Contributors**: Libraries and tools used
