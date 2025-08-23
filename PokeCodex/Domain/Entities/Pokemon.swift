import Foundation

import Foundation

struct Pokemon: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let sprites: Sprites
    let types: [PokemonTypeSlot]
    let abilities: [PokemonAbilitySlot]
}

struct Sprites: Codable, Hashable {
    let frontDefault: String?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

struct PokemonTypeSlot: Codable, Hashable {
    let slot: Int
    let type: PokemonType
}

struct PokemonType: Codable, Hashable {
    let name: String
    let url: String
}

struct PokemonAbilitySlot: Codable, Hashable, Identifiable {
    var id: UUID = UUID()
    let ability: PokemonAbility
    let isHidden: Bool
    let slot: Int
    
    enum CodingKeys: String, CodingKey {
        case ability
        case isHidden = "is_hidden"
        case slot
    }
}

struct PokemonAbility: Codable, Hashable {
    let name: String
    let url: String
}


struct PokemonListItem: Codable, Identifiable {
    let id: Int
    let name: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        url = try container.decode(String.self, forKey: .url)
        
        // Extract ID from URL (e.g., "https://pokeapi.co/api/v2/pokemon/1/" -> 1)
        if let lastComponent = url.components(separatedBy: "/").dropLast().last,
           let id = Int(lastComponent) {
            self.id = id
        } else {
            // Fallback try to extract from name or use a hash
            self.id = name.hashValue
        }
    }
    
    init(id: Int, name: String, url: String) {
        self.id = id
        self.name = name
        self.url = url
    }
}

struct PokemonListResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonListItem]
}
