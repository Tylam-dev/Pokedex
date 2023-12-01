import Foundation

// MARK: - CategoryData
struct PokemonListData: Codable {
    let results: [Result]?
}

// MARK: - Result
struct Result: Codable {
    let name: String?
    let url: String?
}
