import SwiftUI

struct SurfaceCard<Content: View>: View {
    var padding: CGFloat = Spacing.md
    @ViewBuilder let content: () -> Content

    var body: some View {
        content()
            .padding(padding)
            .background(Color.surfacePrimary)
            .clipShape(RoundedRectangle(cornerRadius: Radius.lg))
    }
}

