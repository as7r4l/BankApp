import SwiftUI

struct GoldButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool = false

    var body: some View {
        Button(action: action) {
            ZStack {
                if isLoading {
                    ProgressView()
                        .tint(.appBackground)
                } else {
                    Text(title)
                        .font(.headingSmall)
                        .foregroundStyle(.appBackground)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(LinearGradient.goldGradient)
            .clipShape(RoundedRectangle(cornerRadius: Radius.md))
        }
        .disabled(isLoading)
    }
}

