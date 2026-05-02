import SwiftUI
import Combine
import Supabase

@MainActor // Снова используем @MainActor для безопасного обновления UI
final class AuthViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLogin: Bool = true
    
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var isAuthenticated: Bool = false
    @Published var isDone: Bool = false
    
    func switchMode() {
        errorMessage = ""
        name = ""
        email = ""
        password = ""
    }
    
    func submit() {
        guard validate() else { return }
        
        isLoading = true
        errorMessage = ""
        
        Task {
            do {
                if isLogin {
                    try await AuthService.shared.login(email: email, password: password)
                } else {
                    _ = try await AuthService.shared.register(name: name, email: email, password: password)
                }
                
                // Успех!
                self.isLoading = false
                self.isAuthenticated = true
                self.isDone = true
                
            } catch {
                // Ошибка
                self.isLoading = false
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    private func validate() -> Bool {
        if !isLogin && name.trimmingCharacters(in: .whitespaces).isEmpty {
            errorMessage = "Enter your name"
            return false
        }
        
        if !email.contains("@") {
            errorMessage = "Enter correct email"
            return false
        }
        
        if password.count < 6 {
            errorMessage = "Password is too short"
            return false
        }
        
        return true
    }
}
