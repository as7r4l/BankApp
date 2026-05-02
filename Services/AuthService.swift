import Foundation
import Supabase

final class AuthService {
    static let shared = AuthService()
    private let client = SupabaseManager.shared.client
    
    private init() {}
    
    // Проверка текущей сессии
    var hasSession: Bool {
        // Проверяем, есть ли сохраненный токен
        Task {
            do {
                _ = try await client.auth.session
                return true
            } catch {
                return false
            }
        }
        return false // Упрощенно, для SwiftUI лучше использовать ObservableObject
    }
    
    // MARK: - Регистрация
    func register(name: String, email: String, password: String) async throws -> UserProfile {
        // 1. Создаем пользователя в системе аутентификации Supabase
        let response = try await client.auth.signUp(
            email: email,
            password: password
        )
        
        let userId = response.user.id
        
        // 2. Создаем профиль пользователя в нашей публичной таблице "profiles"
        let newProfile = UserProfile(
            id: userId,
            name: name,
            email: email,
            avatarUrl: nil,
            createdAt: Date()
        )
        
        try await client
            .from("profiles") // Название таблицы в БД
            .insert(newProfile)
            .execute()
        
        // Здесь можно было бы также сгенерировать дефолтную карту,
        // отправив insert в таблицу "cards"
        
        return newProfile
    }
    
    // MARK: - Логин
    func login(email: String, password: String) async throws {
        // Supabase сам проверит пароль и сохранит JWT-токен в защищенное хранилище (Keychain)
        _ = try await client.auth.signIn(email: email, password: password)
    }
    
    // MARK: - Выход
    func logout() async throws {
        try await client.auth.signOut()
    }
}

enum AuthError: LocalizedError {
    case emailAlreadyExists
    case invalidCredentials
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .emailAlreadyExists: return "Email is already taken"
        case .invalidCredentials: return "Invalid email or password"
        case .unknownError: return "Something went wrong"
        }
    }
}
