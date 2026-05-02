//import RealmSwift
//import Foundation
//
//final class RealmService {
//    
//    //Экземпляр
//    static let shared = RealmService()
//    private init() {}
//    
//    private var realm: Realm {
//        do {
//            return try Realm()
//        } catch {
//            fatalError("Realm init failed: \(error)")
//        }
//    }
//    
//    func save(_ object: Object) {
//        do {
//            try realm.write {
//                realm.add(object, update: .modified)
//            }
//        } catch {
//            print("Realm save error: \(error)")
//        }
//    }
//    
//    func fetch<T: Object>(_ type: T.Type) -> Results<T> {
//        return realm.objects(type)
//    }
//    
//    func delete(_ object: Object) {
//        do {
//            try realm.write {
//                realm.delete(object)
//            }
//        } catch {
//            print("Realm delete error: \(error)")
//        }
//    }
//    
//    func update(_ block: () -> Void) {
//        do {
//            try realm.write {
//                block()
//            }
//        } catch {
//            print("Realm update error: \(error)")
//        }
//    }
//    
//    
//}
