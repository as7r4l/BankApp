import Foundation

//enum TransactionType: String, PersistableEnum {
//    case income
//    case expense
//}
//
//enum TransactionCategory: String, PersistableEnum {
//    case food = "Food"
//    case transport = "Transport"
//    case shopping = "Shopping"
//    case entertainment = "Entertainment"
//    case health = "Health"
//    case transfer = "Transfer"
//    case salary = "Salary"
//    case other = "Other"
//    
//    var icon: String {
//        switch self {
//        case .food: return "fork.knife"
//        case .transport: return "car.fill"
//        case .shopping: return "bag.fill"
//        case .entertainment: return "gamecontroller.fill"
//        case .health: return "heart.fill"
//        case .transfer: return "arrow.left.arrow.right"
//        case .salary: return "dollarsign.circle.fill"
//        case .other: return "ellipsis.circle.fill"
//        }
//    }
//}
//
//
//class TransactionObject: Object {
//    @Persisted(primaryKey: true) var id: String = UUID().uuidString
//    @Persisted var amount: Double = 0.0
//    @Persisted var type: TransactionType = .expense
//    @Persisted var category: TransactionCategory = .other
//    @Persisted var note: String = ""
//    @Persisted var date: Date = Date()
//}

struct Transaction: Codable, Identifiable, Sendable {
    let id: UUID
    let cardId: UUID // Внешний ключ: по какой карте прошла операция
    var amount: Double
    var type: String // "income", "expense"
    var category: String
    var note: String
    let date: Date
}
