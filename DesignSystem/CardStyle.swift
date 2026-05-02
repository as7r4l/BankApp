import SwiftUI
import Foundation

enum CardStyle: String, Codable, Sendable {
    case dark = "card_dark"
    case soft = "card_soft"
    case scrypto = "card_scrypto"
    case mt = "mt"
    case cactus = "cactus"
    case halva = "halva"
    case shopper = "shopper"
    case clever = "clever"
    case slash = "slash"
    
    var imageName: String { rawValue }
    
    var textColor: Color {
        switch self {
        case .dark, .scrypto:
            return .white
        case .soft:
            return .black
        case .cactus:
            return .white
        case .mt:
            return .white
        case .halva:
            return .white
        case .shopper:
            return .black
        case .clever:
            return .white
        case .slash:
            return .white
        }
    }
}
