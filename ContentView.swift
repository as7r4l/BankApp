import SwiftUI
import Supabase

struct ContentView: View {
    @State private var isAuthenticated: Bool = false
    @State private var isCheckingSession: Bool = true // Показываем загрузку, пока проверяем
    
    var body: some View {
            ZStack {
                if isCheckingSession {
                    ProgressView()
                        .scaleEffect(1.5)
                } else if isAuthenticated {
                    MainTabView() // <--- ЗАМЕНИТЬ HomeView() НА ЭТО
                        .transition(.opacity)
                }
                else {
                    AuthView {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            isAuthenticated = true
                        }
                    }
                    .transition(.opacity)
                }
            }
            .task {
                await checkSession()
            }
        }
    
    private func checkSession() async {
        do {
            // Пытаемся получить текущую сессию
            _ = try await SupabaseManager.shared.client.auth.session
            isAuthenticated = true
        } catch {
            // Если сессии нет (ошибка), показываем экран авторизации
            isAuthenticated = false
        }
        isCheckingSession = false
    }
}

#Preview {
    ContentView()
}
