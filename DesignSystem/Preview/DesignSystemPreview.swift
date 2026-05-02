import SwiftUI

#Preview("Design System") {
    ScrollView {
        VStack(alignment: .leading, spacing: Spacing.lg) {

            // Colors
            Text("Colors").font(.headingLarge).foregroundStyle(.textPrimary)
            HStack(spacing: Spacing.sm) {
                ForEach([Color.appBackground, .surfacePrimary, .surfaceSecondary,
                         .gold, .goldLight, .success, .error], id: \.self) { color in
                    RoundedRectangle(cornerRadius: Radius.sm)
                        .fill(color)
                        .frame(width: 44, height: 44)
                        .overlay(RoundedRectangle(cornerRadius: Radius.sm)
                            .stroke(Color.surfaceTertiary, lineWidth: 1))
                }
            }

            // Typography
            Text("Typography").font(.headingLarge).foregroundStyle(.textPrimary)
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Display Large").font(.displayLarge).foregroundStyle(.textPrimary)
                Text("Heading Medium").font(.headingMedium).foregroundStyle(.textPrimary)
                Text("Body Large").font(.bodyLarge).foregroundStyle(.textSecondary)
                Text("$12,450.00").font(.monoLarge).foregroundStyle(.gold)
            }

            // Components
            Text("Components").font(.headingLarge).foregroundStyle(.textPrimary)
            GoldButton(title: "Continue") {}
            GoldButton(title: "Loading", isLoading: true) {}

            SurfaceCard {
                VStack(alignment: .leading) {
                    Text("Surface Card").font(.headingSmall).foregroundStyle(.textPrimary)
                    Text("Базовый контейнер для контента").font(.bodyMedium).foregroundStyle(.textSecondary)
                }
            }
        }
        .padding(Spacing.md)
    }
    .background(Color.appBackground)
}
