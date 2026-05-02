import Combine
import SwiftUI
import Supabase

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var userName: String = ""
    @Published var userInitials: String = ""
    @Published var cards: [Card] = []
    @Published var totalBalance: Double = 0.0
    @Published var recentTransactions: [Transaction] = []
    @Published var avatarUrl: String?
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let client = SupabaseManager.shared.client
    
    init() {
        Task {
            await loadUserData()
        }
    }
    

    func loadUserData() async {
        
        isLoading = true
        errorMessage = nil
        
        do {
            let user = try await client.auth.session.user
            let userId = user.id
            
            async let profileTask: UserProfile = try client
                .from("profiles")
                .select()
                .eq("id", value: userId)
                .single()
                .execute()
                .value
            
            async let cardsTask: [Card] = try client
                .from("cards")
                .select()
                .eq("userId", value: userId)
                .execute()
                .value
            
            let profile = try await profileTask
            let fetchedCards = try await cardsTask
            
            self.userName = profile.name
            self.userInitials = String(profile.name.prefix(1)).uppercased()
            self.avatarUrl = profile.avatarUrl
            self.cards = fetchedCards
            
            self.totalBalance = fetchedCards.reduce(0) { $0 + $1.balance }
            
            if !fetchedCards.isEmpty {
                // Собираем массив ID карт
                let cardIds = fetchedCards.map { $0.id.uuidString }
                
                // Делаем запрос: "Дай транзакции, где cardId входит в список наших карт"
                let fetchedTransactions: [Transaction] = try await client
                    .from("transactions")
                    .select()
                    .in("cardId", values: cardIds) // Используем .in для массива значений
                    .order("date", ascending: false) // Сортируем на сервере (от новых к старым)
                    .limit(5) // Берем только последние 5
                    .execute()
                    .value
                
                self.recentTransactions = fetchedTransactions
            }
        } catch {
            self.errorMessage = "Failed to load data: \(error.localizedDescription)"
            print("Error loading data: \(error)")
        }
        
        isLoading = false
        
    }
}

