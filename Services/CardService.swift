import Foundation
import Supabase

final class CardService {
    static let shared = CardService()
    private let client = SupabaseManager.shared.client
    
    private init() {}
    
    /// Функция создания новой карты в таблице 'cards'
    func issueNewCard(for product: ProductCardInfo) async throws {
        // 1. Получаем текущего авторизованного пользователя
        let user = try await client.auth.session.user
        
        // 2. Генерируем данные карты
        // Номер карты: 4444 5555 + 8 случайных цифр
        let cardNumber = "4444 5555 \(Int.random(in: 1000...9999)) \(Int.random(in: 1000...9999))"
        
        let newCard = Card(
            id: UUID(),
            userId: user.id,
            number: cardNumber,
            holderName: "USER NAME", // В идеале достать из профиля, пока оставим заглушку
            balance: 0.0,
            type: product.title,
            expiryDate: "05/30",
            colorHex: "#3B82F6", // Наш синий цвет
            isDefault: false,
            style: product.style
        )
        
        // 3. Отправляем в Supabase
        try await client
            .from("cards")
            .insert(newCard)
            .execute()
    }
}
