import SwiftUI

extension Font {
    // MARK: — Display
    static let displayLarge  = Font.system(size: 40, weight: .bold, design: .rounded)
    static let displayMedium = Font.system(size: 32, weight: .bold, design: .rounded)

    // MARK: — Heading
    static let headingLarge  = Font.system(size: 24, weight: .semibold, design: .rounded)
    static let headingMedium = Font.system(size: 20, weight: .semibold, design: .rounded)
    static let headingSmall  = Font.system(size: 17, weight: .semibold, design: .rounded)

    // MARK: — Body
    static let bodyLarge     = Font.system(size: 16, weight: .regular, design: .rounded)
    static let bodyMedium    = Font.system(size: 14, weight: .regular, design: .rounded)
    static let bodySmall     = Font.system(size: 12, weight: .regular, design: .rounded)

    // MARK: — Label
    static let labelLarge    = Font.system(size: 14, weight: .medium, design: .rounded)
    static let labelSmall    = Font.system(size: 11, weight: .medium, design: .rounded)

    // MARK: — Mono (для сумм и номеров карт)
    static let monoLarge     = Font.system(size: 32, weight: .bold, design: .monospaced)
    static let monoMedium    = Font.system(size: 20, weight: .semibold, design: .monospaced)
    static let monoSmall     = Font.system(size: 14, weight: .regular, design: .monospaced)
}
