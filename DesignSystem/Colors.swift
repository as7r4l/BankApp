import SwiftUI

extension Color {
    // MARK: — Backgrounds
    static let appBg = Color("AppBackground")
    static let appSurface1 = Color("SurfacePrimary")
    static let appSurface2 = Color("SurfaceSecondary")
    static let appSurface3 = Color("SurfaceTertiary")

    // MARK: — Text
    static let appText = Color("TextPrimary")
    static let appTextSub = Color("TextSecondary")
    static let appTextMuted = Color("TextTertiary")

    // MARK: — Gold
    static let appGold = Color("Gold")
    static let appGoldLight = Color("GoldLight")
    static let appGoldDark = Color("GoldDark")

    // MARK: — Semantic
    static let appSuccess = Color("Success")
    static let appError = Color("Error")
}

extension LinearGradient {
    static let goldGradient = LinearGradient(
        colors: [.appGoldLight, .appGold, .appGoldDark],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    static let surfaceGradient = LinearGradient(
        colors: [.appSurface1, .appBg],
        startPoint: .top,
        endPoint: .bottom
    )
}
