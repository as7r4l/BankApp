import SwiftUI

// 1. Перечисление наших вкладок
enum Tab: String, CaseIterable {
    case home = "Home"
    case products = "Products"
    case game = "Play"         // <--- ДОБАВИЛИ НОВУЮ ВКЛАДКУ
//    case chat = "Chat"
    
    // Иконки
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .products: return "square.stack.3d.up.fill"
        case .game: return "gamecontroller.fill" // <--- ИКОНКА ДЖОЙСТИКА
//        case .chat: return "message.fill"
        }
    }
}

// 2. Главный экран-контейнер
struct MainTabView: View {
    @State private var selectedTab: Tab = .home
    
    // ДОБАВЛЯЕМ ЭТУ СТРОЧКУ: Глобальная переменная для скрытия таб-бара
    @AppStorage("hideTabBar") private var hideTabBar: Bool = false
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.appBg.ignoresSafeArea()
            
            Group {
                switch selectedTab {
                case .home: HomeView()
                case .products: ProductsView()
                case .game: CardSlashContainer() // <--- Наш новый контейнер игры
//                case .chat: Text("Chat")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // ПРЯЧЕМ ТАБ-БАР, ЕСЛИ hideTabBar == true
            if !hideTabBar {
                CustomTabBar(selectedTab: $selectedTab)
                    .padding(.bottom, 10)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        // Добавляем плавную анимацию исчезновения
        .animation(.easeInOut(duration: 0.3), value: hideTabBar)
        .onAppear {
            hideTabBar = false
        }
    }
}

// 3. Дизайн самого Таб-бара
struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    
    var body: some View {
        HStack {
            ForEach(Tab.allCases, id: \.self) { tab in
                Spacer()
                
                Button {
                    // Добавляем пружинистую анимацию при переключении
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 24))
                            // Если вкладка активна — красим вашим золотым градиентом, иначе в серый
                            .foregroundStyle(
                                selectedTab == tab ? AnyShapeStyle(LinearGradient.goldGradient) : AnyShapeStyle(Color.gray.opacity(0.6))
                            )
                            // Анимация увеличения активной иконки (как на референсе)
                            .scaleEffect(selectedTab == tab ? 1.1 : 1.0)
                        
                        Text(tab.rawValue)
                            .font(.system(size: 10, weight: .semibold, design: .rounded))
                            .foregroundStyle(selectedTab == tab ? Color.appText : Color.gray.opacity(0.6))
                    }
                }
                
                Spacer()
            }
        }
        .padding(.vertical, 15)
        // Если хочешь прям чисто белый фон, как на картинке — используй Color.white
        // Но для поддержки темной темы лучше использовать твой Color.appSurface1
        .background(Color.appSurface1)
        .clipShape(RoundedRectangle(cornerRadius: 30)) // Сильное скругление
        // Добавляем красивую тень для эффекта "парения"
        .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: 8)
        .padding(.horizontal, 20) // Отступы от краев экрана
    }
}

#Preview {
    MainTabView()
}
