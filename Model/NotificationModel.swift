//import RealmSwift
//import Foundation
//
//enum NotificationType: String, PersistableEnum {
//    case transaction = "transaction"
//    case security = "security"
//    case promo = "promo"
//    case system = "system"
//    
//    
//    var icon: String {
//        switch self {
//        case .transaction: return "arrow.left.arrow.right.circle.fill"
//        case .security: return "lock.shield.fill"
//        case .promo: return "star.fill"
//        case .system: return "bell.fill"
//        }
//    }
//}
//
//
//class NotificationObject: Object {
//    @Persisted(primaryKey: true) var id: String = UUID().uuidString
//    @Persisted var title: String = ""
//    @Persisted var message: String = ""
//    @Persisted var type: NotificationType = .system
//    @Persisted var isRead: Bool = false
//    @Persisted var date: Date = Date()
//}
