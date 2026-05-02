import SwiftUI
import Supabase

struct ProductsView: View {
    var body: some View {
        NavigationView {
            ZStack {
                // Фон подстраивается под тему
                Color.appBg.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        ForEach(sampleProducts) { product in
                            ProductItemView(product: product)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    // Отступ снизу, чтобы плавающий таб-бар не перекрывал последнюю карту
                    .padding(.bottom, 120)
                }
            }
            .navigationTitle("Продукты")
        }
    }
}

// MARK: - Дизайн одной карточки продукта
struct ProductItemView: View {
    let product: ProductCardInfo
    
    // Синий цвет как на скриншотах
    let accentBlue = Color(hex: "#3B82F6")
    
    @State private var isProcessing = false
    @State private var showSuccess = false
    
    
    var body: some View {
        VStack(spacing: 20) {
            // 1. Заголовок и подзаголовок
            VStack(spacing: 6) {
                Text(product.title)
                    .font(.system(size: 24, weight: .bold, design: .default))
                    .foregroundStyle(Color.appText)
                
                Text(product.subtitle)
                    .font(.system(size: 14))
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
            }
            
            // 2. Изображение карты
            Image(product.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 190)
                // Легкая тень для самой карточки
                .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
            
            // 3. Список преимуществ (буллиты)
            VStack(alignment: .leading, spacing: 14) {
                ForEach(product.features, id: \.self) { feature in
                    HStack(alignment: .top, spacing: 12) {
                        // Синяя точка
                        Circle()
                            .fill(accentBlue)
                            .frame(width: 6, height: 6)
                            .offset(y: 7) // Выравнивание по центру первой строки текста
                        
                        Text(feature)
                            .font(.system(size: 15, weight: .regular))
                            .foregroundStyle(Color.gray) // Серый текст как на референсе
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 8)
            
            // 4. Кнопки
            HStack(spacing: 16) {
                // Кнопка "Оформить"
                Button {
                        issueCardAction()
                    } label: {
                        ZStack {
                        if isProcessing {
                        ProgressView()
                            .tint(.white)
                        } else {
                                Text(showSuccess ? "Готово!" : "Оформить")
                                .font(.system(size: 16, weight: .semibold))
                                        }
                                    }
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(showSuccess ? Color.green : accentBlue)
                                    .clipShape(Capsule())
                                }
                                .disabled(isProcessing || showSuccess)
                
                // Кнопка "Подробнее"
                Button {
                    // Действие подробнее
                } label: {
                    Text("Подробнее")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.appText)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                }
            }
            .padding(.top, 8)
        }
        .padding(24)
        .background(Color.appSurface1) // Подложка карточки
        .clipShape(RoundedRectangle(cornerRadius: 24))
        // Тень всей белой плашки
        .shadow(color: .black.opacity(0.08), radius: 20, x: 0, y: 10)
    }
    
    private func issueCardAction() {
        isProcessing = true
        
        Task {
            do {
                try await CardService.shared.issueNewCard(for: product)
                
                // Если всё ок — показываем успех
                await MainActor.run {
                    withAnimation {
                        isProcessing = false
                        showSuccess = true
                    }
                    
                    // Через 2 секунды возвращаем кнопку в обычное состояние
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showSuccess = false
                    }
                }
            } catch {
                print("❌ Ошибка при оформлении: \(error)")
                await MainActor.run { isProcessing = false }
            }
        }
    }
    
}

#Preview {
    ProductsView()
}
