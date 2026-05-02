import Foundation

//enum CardType: String, PersistableEnum {
//    case visa = "Visa"
//    case mastercard = "Mastercard"
//}
//
//class CardObject: Object {
//    @Persisted(primaryKey: true) var id: String = UUID().uuidString
//    @Persisted var number: String = ""
//    @Persisted var holderName: String = ""
//    @Persisted var balance: Double = 0.0
//    @Persisted var type: CardType = .visa
//    @Persisted var expiryDate: String = ""
//    //
//    @Persisted var colorHex: String = ""
//    //
//    @Persisted var isDefault: Bool = false
//    @Persisted var transactions: List<TransactionObject>
//    @Persisted var style: CardStyle = .soft
//}

struct Card: Codable, Identifiable, Sendable {
    let id: UUID
        let userId: UUID // Внешний ключ: кому принадлежит карта
        var number: String
        var holderName: String
        var balance: Double
        var type: String // "Visa" или "Mastercard"
        var expiryDate: String
        var colorHex: String
        var isDefault: Bool
        var style: CardStyle // "soft", "dark"
}
