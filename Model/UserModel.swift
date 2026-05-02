import Foundation

nonisolated struct UserProfile: Codable, Identifiable, Sendable {
    let id: UUID
    var name: String
    var email: String
    //var password: String = ""
    var avatarUrl: String?
    let createdAt: Date

    init(id: UUID, name: String, email: String, avatarUrl: String? = nil, createdAt: Date = Date()) {
            self.id = id
            self.name = name
            self.email = email
            self.avatarUrl = avatarUrl
            self.createdAt = createdAt
        }
    
}
