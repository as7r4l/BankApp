import SpriteKit
import SwiftUI
import UIKit

// MARK: - Состояния Игры
enum GameState {
    case menu
    case playing
    case leaderboard
}

// MARK: - Данные для колеса (Синяя тема)
struct WheelReward {
    let label: String
    let color: Color
    let isWin: Bool
    let weight: Int // <--- Добавили шанс выпадения (в процентах)
    
    static func dailySegments() -> [WheelReward] {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let categories = ["Fastfood", "Tech", "Travel", "Shopping", "Coffee", "Gaming", "Groceries"]
        let todayCategory = categories[dayOfYear % categories.count]
        
        let blue = Color(hex: "#007AFF")
        let dark = Color.appSurface1
        
        // ВНИМАНИЕ: Сумма всех weight должна быть равна 100
        return [
            WheelReward(label: "2% \(todayCategory)", color: blue, isWin: true, weight: 15), // 15% шанс
            WheelReward(label: "No luck", color: dark, isWin: false, weight: 25),             // 25% шанс
            WheelReward(label: "5% \(todayCategory)", color: blue, isWin: true, weight: 10),  // 10% шанс
            WheelReward(label: "No luck", color: dark, isWin: false, weight: 25),             // 25% шанс
            WheelReward(label: "10% \(todayCategory)", color: blue, isWin: true, weight: 5),  // 5% шанс (Джекпот)
            WheelReward(label: "No luck", color: dark, isWin: false, weight: 5),              // 5% шанс
            WheelReward(label: "3% \(todayCategory)", color: blue, isWin: true, weight: 10),  // 10% шанс
            WheelReward(label: "No luck", color: dark, isWin: false, weight: 5)               // 5% шанс
        ]
    }
}

// MARK: - Главный Контейнер (Маршрутизатор)
struct CardSlashContainer: View {
    @State private var gameState: GameState = .menu
    @AppStorage("hideTabBar") private var hideTabBar: Bool = false
    
    var body: some View {
        ZStack {
            Color.appBg.ignoresSafeArea()
            
            switch gameState {
            case .menu:
                StartMenuView(gameState: $gameState)
                    .onAppear { hideTabBar = false } // В меню таб-бар виден
            case .playing:
                CardSlashGameView(gameState: $gameState)
                    .onAppear { hideTabBar = true }  // В игре таб-бар спрятан
            case .leaderboard:
                LeaderboardView(gameState: $gameState)
                    .onAppear { hideTabBar = true }  // В лидерборде спрятан
            }
        }
        .animation(.easeInOut, value: gameState)
    }
}

// MARK: - 1. Стартовое Меню
struct StartMenuView: View {
    @Binding var gameState: GameState
    @AppStorage("totalCoins") private var totalCoins: Int = 0
    @AppStorage("highScore") private var highScore: Int = 0
    @State private var showWheel = false
    @AppStorage("hideTabBar") private var hideTabBar: Bool = false
    @State private var showReferral = false
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Логотип Игры
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [Color(hex: "#5AC8FA"), Color(hex: "#007AFF")], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 120, height: 120)
                        .shadow(color: Color(hex: "#007AFF").opacity(0.4), radius: 20, x: 0, y: 10)
                    
                    Text("💳")
                        .font(.system(size: 60))
                        .rotationEffect(.degrees(-15))
                }
                
                Text("CARD SLASH")
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .foregroundStyle(Color.appText)
            }
            
            // Статистика
            HStack(spacing: 20) {
                StatCard(title: "MTCoins", value: "\(totalCoins)", iconName: "mtCoin", isImage: true, color: Color(hex: "#FFD700"))
                StatCard(title: "Best Score", value: "\(highScore)", iconName: "🏆", isImage: false, color: Color(hex: "#007AFF"))
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            
            
            
            
            
            
            
            
            
            // Кнопки управления
            VStack(spacing: 16) {
                // START GAME
                Button {
                    gameState = .playing
                } label: {
                    Text("START GAME")
                        .font(.system(size: 20, weight: .heavy, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 65)
                        .background(LinearGradient(colors: [Color(hex: "#5AC8FA"), Color(hex: "#007AFF")], startPoint: .leading, endPoint: .trailing))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: Color(hex: "#007AFF").opacity(0.4), radius: 15, x: 0, y: 8)
                }
                
                HStack(spacing: 16) {
                    // LEADERBOARD
                    Button {
                        gameState = .leaderboard
                    } label: {
                        HStack {
                            Image(systemName: "list.star")
                            Text("Leaders")
                        }
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.appText)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color.appSurface1)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    
                    // FORTUNE WHEEL
                    Button {
                        hideTabBar = true // Прячем таб-бар перед открытием колеса
                        showWheel = true
                    } label: {
                        HStack {
                            Text("🎰")
                            Text("Spin")
                        }
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color(hex: "#0051A8"))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 120) // Отступ для таб-бара
        }
        .sheet(isPresented: $showWheel, onDismiss: {
            hideTabBar = false // Возвращаем таб-бар после закрытия
        }) {
            SpinWheelView(isPresented: $showWheel, totalCoins: totalCoins) {
                totalCoins -= 1000
            }
            .presentationDetents([.large])
        }
        
        
        
        
        
        VStack{
            HStack {
                Spacer()
                Button {
                    hideTabBar = true
                    showReferral = true
                } label: {
                    HStack(spacing: 6) {
                        Text("🎁")
                            .font(.system(size: 14))
                        Text("Free Spin")
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.appText)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(Color.appSurface1)
                    .clipShape(Capsule())
                    // Легкая тень и обводка для объема
                    .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
                    .overlay(Capsule().stroke(Color(hex: "#007AFF").opacity(0.3), lineWidth: 1))
                }
                .padding(.top, 16)
                .padding(.trailing, 20)
                // Второй .sheet вешаем ТОЛЬКО на эту кнопку, чтобы избежать конфликтов
                .sheet(isPresented: $showReferral, onDismiss: {
                    hideTabBar = false
                }) {
                    ReferralView(isPresented: $showReferral)
                        .presentationDetents([.large])
                        .presentationDragIndicator(.visible)
                }
            }
            Spacer()
        }
        
        
        
        
        
        
        
    }
}

// Карточка статистики
//struct StatCard: View {
//    let title: String
//    let value: String
//    let icon: String
//    let color: Color
//    
//    var body: some View {
//        VStack(spacing: 8) {
//            Text(icon)
//                .font(.system(size: 24))
//            Text(value)
//                .font(.system(size: 22, weight: .bold, design: .rounded))
//                .foregroundStyle(Color.appText)
//            Text(title)
//                .font(.system(size: 13, weight: .semibold, design: .rounded))
//                .foregroundStyle(Color.gray)
//        }
//        .frame(maxWidth: .infinity)
//        .padding(.vertical, 16)
//        .background(Color.appSurface1)
//        .clipShape(RoundedRectangle(cornerRadius: 20))
//        .overlay(RoundedRectangle(cornerRadius: 20).stroke(color.opacity(0.3), lineWidth: 1))
//    }
//}


struct StatCard: View {
    let title: String
    let value: String
    let iconName: String
    let isImage: Bool
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            if isImage {
                Image(iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
            } else {
                Text(iconName).font(.system(size: 24))
            }
            Text(value)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(Color.appText)
            Text(title)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.appSurface1)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(color.opacity(0.3), lineWidth: 1))
    }
}


// MARK: - 2. Таблица лидеров (Заглушка)
struct LeaderboardView: View {
    @Binding var gameState: GameState
    @AppStorage("highScore") private var highScore: Int = 0
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    gameState = .menu
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundStyle(Color.appText)
                        .padding()
                        .background(Color.appSurface1)
                        .clipShape(Circle())
                }
                Spacer()
                Text("Leaderboard")
                    .font(.title2.bold())
                    .foregroundStyle(Color.appText)
                Spacer()
                Color.clear.frame(width: 50, height: 50)
            }
            .padding()
            
            VStack(spacing: 12) {
                LeaderRow(rank: 1, name: "AlexM", score: 3450, isMe: false)
                LeaderRow(rank: 2, name: "CryptoKing", score: 2800, isMe: false)
                LeaderRow(rank: 3, name: "You", score: highScore, isMe: true)
                LeaderRow(rank: 4, name: "Sarah99", score: 1200, isMe: false)
            }
            .padding(.horizontal)
            
            Spacer()
        }
    }
}

struct LeaderRow: View {
    let rank: Int
    let name: String
    let score: Int
    let isMe: Bool
    
    var body: some View {
        HStack {
            Text("#\(rank)")
                .font(.headline)
                .foregroundStyle(Color.gray)
                .frame(width: 40, alignment: .leading)
            
            Text(name)
                .font(.headline)
                .foregroundStyle(isMe ? Color(hex: "#007AFF") : Color.appText)
            
            Spacer()
            
            Text("\(score)")
                .font(.headline.bold())
                .foregroundStyle(Color(hex: "#FFD700"))
            Image("mtCoin")
                .resizable()
                .scaledToFit()
                .frame(width: 18, height: 18)
        }
        .padding()
        .background(Color.appSurface1)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(isMe ? Color(hex: "#007AFF") : Color.clear, lineWidth: 2))
    }
}

// MARK: - 3. Сама Игра
struct CardSlashGameView: View {
    @Binding var gameState: GameState
    @AppStorage("totalCoins") private var totalCoins: Int = 0
    @AppStorage("highScore") private var highScore: Int = 0
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                Color.appBg.ignoresSafeArea()
                
                SpriteView(scene: makeScene(size: geo.size), options: [.allowsTransparency])
                    .ignoresSafeArea()
                
                // Кнопка выхода во время игры
                Button {
                    gameState = .menu
                } label: {
                    Image(systemName: "xmark")
                        .font(.title3.bold())
                        .foregroundStyle(Color.appText)
                        .padding(12)
                        .background(Color.appSurface1.opacity(0.8))
                        .clipShape(Circle())
                }
                .padding(.leading, 20)
                .padding(.top, 50) // Смещение под Dynamic Island
            }
        }
    }
    
    func makeScene(size: CGSize) -> CardSlashScene {
        let scene = CardSlashScene()
        scene.size = size
        scene.scaleMode = .resizeFill
        
        // Коллбэк при завершении игры
        scene.onGameOver = { sessionScore in
            DispatchQueue.main.async {
                self.totalCoins += sessionScore
                if sessionScore > self.highScore {
                    self.highScore = sessionScore
                }
                self.gameState = .menu // Возвращаемся в меню!
            }
        }
        
        return scene
    }
}

// MARK: - Колесо Фортуны (Синее)
struct PieSlice: Shape {
    let startAngle: Angle
    let endAngle: Angle
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        path.move(to: center)
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.closeSubpath()
        return path
    }
}

struct SpinWheelView: View {
    @Binding var isPresented: Bool
    @State private var rotation: Double = 0
    @State private var isSpinning: Bool = false
    @State private var result: String = ""
    @State private var showResult: Bool = false
    
    let totalCoins: Int
    let onSpin: () -> Void
    let segments = WheelReward.dailySegments()
    var canSpin: Bool { totalCoins >= 1000 }
    
    var body: some View {
        ZStack {
            Color.appBg.ignoresSafeArea()
            
            VStack(spacing: 28) {
                HStack {
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color.gray)
                            .padding(10)
                            .background(Color.appSurface1)
                            .clipShape(Circle())
                    }
                    Spacer()
                    Text("Daily Fortune")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.appText)
                    Spacer()
                    HStack(spacing: 6) {
                        Text("MTCoin").font(.system(size: 14))
                        Text("\(totalCoins)")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundStyle(Color(hex: "#007AFF"))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.appSurface1)
                    .clipShape(Capsule())
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                Spacer()
                
                // Колесо
                ZStack {
                    Circle()
                        .fill(Color(hex: "#007AFF").opacity(0.1))
                        .frame(width: 310, height: 310)
                        .blur(radius: 20)
                    
                    ZStack {
                        let segmentAngle = 360.0 / Double(segments.count)
                        ForEach(0..<segments.count, id: \.self) { i in
                            let start = Double(i) * segmentAngle - 90 - (segmentAngle / 2)
                            let end = start + segmentAngle
                            
                            ZStack {
                                PieSlice(startAngle: .degrees(start), endAngle: .degrees(end))
                                    .fill(segments[i].color)
                                    .overlay(PieSlice(startAngle: .degrees(start), endAngle: .degrees(end)).stroke(Color.appBg, lineWidth: 2))
                                
                                let midAngle = (start + end) / 2
                                Text(segments[i].label)
                                    .font(.system(size: segments[i].isWin ? 11 : 9, weight: segments[i].isWin ? .black : .bold, design: .rounded))
                                    .foregroundStyle(segments[i].isWin ? Color.white : Color.gray)
                                    .rotationEffect(.degrees(midAngle + 90))
                                    .offset(x: 100 * cos(midAngle * .pi / 180), y: 100 * sin(midAngle * .pi / 180))
                            }
                        }
                    }
                    .frame(width: 300, height: 300)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color(hex: "#007AFF").opacity(0.5), lineWidth: 3))
                    .rotationEffect(.degrees(rotation))
                    
                    Circle()
                        .fill(Color.appBg)
                        .frame(width: 56, height: 56)
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
                        .overlay(
                            Circle().stroke(LinearGradient(colors: [Color(hex: "#5AC8FA"), Color(hex: "#0051A8")], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 4)
                        )
                    Text("💎").font(.system(size: 24))
                }
                .frame(width: 300, height: 300)
                .overlay(alignment: .top) {
                    Triangle()
                        .fill(LinearGradient(colors: [Color(hex: "#5AC8FA"), Color(hex: "#007AFF")], startPoint: .top, endPoint: .bottom))
                        .frame(width: 24, height: 30)
                        .rotationEffect(.degrees(180))
                        .shadow(color: .black.opacity(0.4), radius: 3, x: 0, y: 2)
                        .offset(y: -15)
                }
                
                Spacer()
                
                ZStack {
                    if showResult {
                        Text(result)
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundStyle(result == "No luck" ? Color.gray : Color(hex: "#007AFF"))
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color.appSurface1)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(result == "No luck" ? Color.clear : Color(hex: "#007AFF").opacity(0.5), lineWidth: 1))
                            .transition(.scale(scale: 0.8).combined(with: .opacity))
                    } else {
                        Text(canSpin ? "1000 MTCoins per spin" : "Not enough coins")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundStyle(Color.gray)
                    }
                }
                .frame(height: 50)
                
                Button(action: spin) {
                    Text(isSpinning ? "Spinning..." : "Spin")
                        .font(.system(size: 18, weight: .heavy, design: .rounded))
                        .foregroundStyle(canSpin && !isSpinning ? Color.white : Color.gray)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(
                            canSpin && !isSpinning
                            ? LinearGradient(colors: [Color(hex: "#5AC8FA"), Color(hex: "#007AFF"), Color(hex: "#0051A8")], startPoint: .topLeading, endPoint: .bottomTrailing)
                            : LinearGradient(colors: [Color.appSurface1, Color.appSurface1], startPoint: .leading, endPoint: .trailing)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                }
                .disabled(!canSpin || isSpinning)
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
            }
        }
    }
    
    func spin() {
        guard canSpin && !isSpinning else { return }
        isSpinning = true
        showResult = false
        onSpin()
        
        let segmentAngle = 360.0 / Double(segments.count)

                let totalWeight = segments.reduce(0) { $0 + $1.weight }
                let randomValue = Int.random(in: 1...totalWeight)
                
                var currentSum = 0
                var randomSegment = 0
                
                for (index, segment) in segments.enumerated() {
                    currentSum += segment.weight
                    if randomValue <= currentSum {
                        randomSegment = index
                        break
                    }
                }
        let targetOffset = 360.0 - (Double(randomSegment) * segmentAngle)
        let currentRemainder = rotation.truncatingRemainder(dividingBy: 360.0)
        
        var angleToAdd = targetOffset - currentRemainder
        if angleToAdd < 0 { angleToAdd += 360 }
        
        let finalRotation = rotation + (360.0 * 5) + angleToAdd
        
        withAnimation(.easeOut(duration: 4.0)) { rotation = finalRotation }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            let impact = UIImpactFeedbackGenerator(style: .heavy)
            impact.impactOccurred()
            result = segments[randomSegment].label
            withAnimation(.spring()) { showResult = true }
            isSpinning = false
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

// MARK: - Сцена SpriteKit (Без экрана поражения, только логика игры)
class CardSlashScene: SKScene {
    
    var onGameOver: ((Int) -> Void)? // Коллбэк для SwiftUI
    
    private var coinIcon: SKSpriteNode!
    private var sessionCoins: Int = 0
    private var lives: Int = 3
    private var spawnTimer: Timer?
    private var gameTimer: Timer?
    private var timeLeft: Int = 60
    private var isGameOver: Bool = false
    
    private var sessionCoinsLabel: SKLabelNode!
    private var livesLabel: SKLabelNode!
    private var timerLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        backgroundColor = .clear
        setupBackground()
        setupUI()
        scheduleNextSpawn()
        startGameTimer()
    }
    
    
    
    
    private func setupBackground() {
        for i in 0..<20 {
            let line = SKShapeNode()
            let path = CGMutablePath()
            path.move(to: CGPoint(x: 0, y: CGFloat(i) * 50))
            path.addLine(to: CGPoint(x: size.width, y: CGFloat(i) * 50))
            line.path = path
            line.strokeColor = UIColor.label.withAlphaComponent(0.05)
            line.lineWidth = 1
            addChild(line)
        }
    }
    
    private func setupUI() {
        timerLabel = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        timerLabel.text = "60"
        timerLabel.fontSize = 38
        timerLabel.fontColor = UIColor.label
        timerLabel.horizontalAlignmentMode = .center
        timerLabel.position = CGPoint(x: size.width / 2, y: size.height - 110)
        addChild(timerLabel)
        
        // Картинка монетки
        coinIcon = SKSpriteNode(imageNamed: "mtCoin")
        coinIcon.size = CGSize(width: 35, height: 25)
        coinIcon.position = CGPoint(x: size.width - 30, y: size.height - 100)
        addChild(coinIcon)
                
                // Текст очков
        sessionCoinsLabel = SKLabelNode(fontNamed: "AvenirNext-DemiBold")
        sessionCoinsLabel.text = "0"
        sessionCoinsLabel.fontSize = 26
        sessionCoinsLabel.fontColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1)
        sessionCoinsLabel.horizontalAlignmentMode = .right
        sessionCoinsLabel.position = CGPoint(x: size.width - 55, y: size.height - 110)
        addChild(sessionCoinsLabel)
        
        livesLabel = SKLabelNode(fontNamed: "AvenirNext-DemiBold")
        livesLabel.text = "❤️❤️❤️"
        livesLabel.fontSize = 22
        livesLabel.horizontalAlignmentMode = .left
        livesLabel.position = CGPoint(x: 20, y: size.height - 110)
        addChild(livesLabel)
    }
    
//    private func startSpawning() {
//        spawnTimer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { _ in
//            guard !self.isGameOver else { return }
//            if Int.random(in: 0...4) == 0 { self.spawnBomb() } else { self.spawnCard() }
//        }
//    }
    
    
    private func scheduleNextSpawn() {
            guard !isGameOver else { return }
            
            // 1. Высчитываем прогресс (от 0.0 на 60 секундах до 1.0 на 0 секундах)
            let progress = 1.0 - (Double(max(0, timeLeft)) / 60.0)
            
            // 2. Уменьшаем паузу между спавном (от 0.8 сек в начале до 0.3 сек в конце)
            let spawnDelay = max(0.3, 0.8 - (progress * 0.5))
            
            // 3. Ускоряем полет (было 1.5-2.2, в конце будет 0.8-1.2 секунды на пролет всего экрана)
            let minFly = max(0.8, 1.5 - (progress * 0.7))
            let maxFly = max(1.2, 2.2 - (progress * 1.0))
            
            let wait = SKAction.wait(forDuration: spawnDelay)
            let spawn = SKAction.run { [weak self] in
                guard let self = self, !self.isGameOver else { return }
                
                if Int.random(in: 0...4) == 0 {
                    // Бомбы делаем чуть медленнее карт, чтобы игрок успел среагировать
                    self.spawnBomb(minDuration: minFly + 0.3, maxDuration: maxFly + 0.3)
                } else {
                    self.spawnCard(minDuration: minFly, maxDuration: maxFly)
                }
                
                // Зацикливаем спавн
                self.scheduleNextSpawn()
            }
            
            // Запускаем с ключом, чтобы потом можно было легко остановить
            run(SKAction.sequence([wait, spawn]), withKey: "spawning")
        }
    
    
    
    
    
    
    private func spawnCard(minDuration: Double, maxDuration: Double) {
        let cardNames = ["mt", "halva", "cactus", "clever", "shopper"]
//        let card = SKSpriteNode(imageNamed: cardNames.randomElement()!)
//        card.size = CGSize(width: 150, height: 95)
//        card.name = "card"
//        let randomX = CGFloat.random(in: 80...(size.width - 80))
//        card.position = CGPoint(x: randomX, y: -50)
//        card.zRotation = CGFloat.random(in: -0.5...0.5)
//        addChild(card)
//        
//        let targetX = CGFloat.random(in: 80...(size.width - 80))
//        let flyUp = SKAction.move(to: CGPoint(x: targetX, y: size.height + 100), duration: Double.random(in: 1.5...2.2))
//        let rotate = SKAction.rotate(byAngle: CGFloat.random(in: -2...2), duration: 2.0)
//        let missLife = SKAction.run { [weak self] in
//            guard let self = self, !self.isGameOver else { return }
//            if card.name == "card" { self.missedCard(at: CGPoint(x: targetX, y: self.size.height - 150)) }
//        }
//        card.run(SKAction.sequence([SKAction.group([flyUp, rotate]), missLife, SKAction.removeFromParent()]))
//    }
        let card = SKSpriteNode(imageNamed: cardNames.randomElement()!)
                card.size = CGSize(width: 150, height: 95)
                card.name = "card"
                let randomX = CGFloat.random(in: 80...(size.width - 80))
                card.position = CGPoint(x: randomX, y: -50)
                card.zRotation = CGFloat.random(in: -0.5...0.5)
                addChild(card)
                
                let targetX = CGFloat.random(in: 80...(size.width - 80))
                
                // ИСПОЛЬЗУЕМ ДИНАМИЧЕСКУЮ СКОРОСТЬ
                let flyUp = SKAction.move(to: CGPoint(x: targetX, y: size.height + 100), duration: Double.random(in: minDuration...maxDuration))
                let rotate = SKAction.rotate(byAngle: CGFloat.random(in: -2...2), duration: 2.0)
                let missLife = SKAction.run { [weak self] in
                    guard let self = self, !self.isGameOver else { return }
                    if card.name == "card" { self.missedCard(at: CGPoint(x: targetX, y: self.size.height - 150)) }
                }
                card.run(SKAction.sequence([SKAction.group([flyUp, rotate]), missLife, SKAction.removeFromParent()]))
            }
            
            private func spawnBomb(minDuration: Double, maxDuration: Double) {
                let bomb = SKNode()
                bomb.name = "bomb"
                let circle = SKShapeNode(circleOfRadius: 30)
                circle.fillColor = UIColor(red: 1.0, green: 0.32, blue: 0.32, alpha: 1)
                circle.strokeColor = .clear
                let label = SKLabelNode(text: "💣")
                label.fontSize = 40
                label.verticalAlignmentMode = .center
                bomb.addChild(circle)
                bomb.addChild(label)
                let randomX = CGFloat.random(in: 80...(size.width - 80))
                bomb.position = CGPoint(x: randomX, y: -50)
                addChild(bomb)
                
                // ИСПОЛЬЗУЕМ ДИНАМИЧЕСКУЮ СКОРОСТЬ
                let flyUp = SKAction.move(to: CGPoint(x: randomX, y: size.height + 100), duration: Double.random(in: minDuration...maxDuration))
                let rotate = SKAction.rotate(byAngle: CGFloat.random(in: -1...1), duration: 2.0)
                bomb.run(SKAction.sequence([SKAction.group([flyUp, rotate]), SKAction.removeFromParent()]))
            }
    
    private func spawnBomb() {
        let bomb = SKNode()
        bomb.name = "bomb"
        let circle = SKShapeNode(circleOfRadius: 30)
        circle.fillColor = UIColor(red: 1.0, green: 0.32, blue: 0.32, alpha: 1)
        circle.strokeColor = .clear
        let label = SKLabelNode(text: "💣")
        label.fontSize = 40
        label.verticalAlignmentMode = .center
        bomb.addChild(circle)
        bomb.addChild(label)
        let randomX = CGFloat.random(in: 80...(size.width - 80))
        bomb.position = CGPoint(x: randomX, y: -50)
        addChild(bomb)
        
        let flyUp = SKAction.move(to: CGPoint(x: randomX, y: size.height + 100), duration: Double.random(in: 1.8...2.5))
        let rotate = SKAction.rotate(byAngle: CGFloat.random(in: -1...1), duration: 2.0)
        bomb.run(SKAction.sequence([SKAction.group([flyUp, rotate]), SKAction.removeFromParent()]))
    }
    
    private func missedCard(at position: CGPoint) {
        lives -= 1
        updateLives()
        showFloatingText("Miss! -❤️", at: position, color: UIColor(red: 1.0, green: 0.32, blue: 0.32, alpha: 1))
        let flash = SKShapeNode(rect: CGRect(origin: .zero, size: size))
        flash.fillColor = UIColor.red.withAlphaComponent(0.12)
        flash.strokeColor = .clear
        flash.zPosition = 5
        addChild(flash)
        flash.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.3), SKAction.removeFromParent()]))
        if lives <= 0 { endGame() }
    }
    
    private func startGameTimer() {
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            guard !self.isGameOver else { return }
            self.timeLeft -= 1
            self.timerLabel.text = "\(self.timeLeft)"
            if self.timeLeft <= 10 { self.timerLabel.fontColor = UIColor.red }
            if self.timeLeft <= 0 { self.endGame() }
        }
    }
    
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            let previousLocation = touch.previousLocation(in: self)
            
            // Вычисляем вектор свайпа (направление и скорость пальца)
            let swipeVector = CGVector(dx: location.x - previousLocation.x, dy: location.y - previousLocation.y)
            
            showSlashEffect(at: location)
            
            let nodes = self.nodes(at: location)
            for node in nodes {
                if node.name == "card" {
                    // Передаем координаты и вектор в функцию
                    slashCard(node as! SKSpriteNode, at: location, swipeVector: swipeVector)
                } else if node.parent?.name == "card", let parent = node.parent as? SKSpriteNode {
                    slashCard(parent, at: location, swipeVector: swipeVector)
                } else if node.name == "bomb" {
                    slashBomb(node)
                } else if node.parent?.name == "bomb", let parent = node.parent {
                    slashBomb(parent)
                }
            }
        }
    
    
    
//    private func slashCard(_ card: SKSpriteNode) {
//        guard card.name == "card" else { return }
//        card.name = "slashed"
//        card.removeAllActions()
//        
//        sessionCoins += 10
//        sessionCoinsLabel.text = "\(sessionCoins)"
//                
//                // Анимация картинки при резе
//                let pop = SKAction.sequence([
//                    SKAction.scale(to: 1.3, duration: 0.1),
//                    SKAction.scale(to: 1.0, duration: 0.1)
//                ])
//                coinIcon.run(pop)
//        
//        let scaleUp = SKAction.scale(to: 1.2, duration: 0.05)
//        let fadeOut = SKAction.fadeOut(withDuration: 0.15)
//        card.run(SKAction.sequence([scaleUp, fadeOut, SKAction.removeFromParent()]))
//        
//        // Синий текст и частицы
//        showFloatingText("+10 MTCoins", at: card.position, color: UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1))
//        showSlashParticles(at: card.position)
//         
//        
//    }
    
    
    
    
    
    
    
    
    
    
    
    
    
//    private func slashCard(_ card: SKSpriteNode) {
//            guard card.name == "card" else { return }
//            card.name = "slashed"
//            card.removeAllActions()
//            
//            sessionCoins += 10
//            sessionCoinsLabel.text = "\(sessionCoins)"
//            
//            // Легкий пульс иконки MTCoin
//            let pop = SKAction.sequence([
//                SKAction.scale(to: 1.3, duration: 0.1),
//                SKAction.scale(to: 1.0, duration: 0.1)
//            ])
//            coinIcon.run(pop)
//            
//            // MARK: - НОВАЯ АНИМАЦИЯ РАЗРУБАНИЯ
//            if let texture = card.texture {
//                let size = card.size
//                let position = card.position
//                let zRot = card.zRotation
//                
//                // 1. Левая половинка
//                // Вырезаем левую часть (от 0.0 до 0.5 по ширине)
//                let leftTexture = SKTexture(rect: CGRect(x: 0, y: 0, width: 0.5, height: 1.0), in: texture)
//                let leftHalf = SKSpriteNode(texture: leftTexture, size: CGSize(width: size.width / 2, height: size.height))
//                // Магия: сдвигаем точку крепления на правый край, чтобы половинки идеально сошлись
//                leftHalf.anchorPoint = CGPoint(x: 1.0, y: 0.5)
//                leftHalf.position = position
//                leftHalf.zRotation = zRot
//                leftHalf.zPosition = card.zPosition
//                
//                // 2. Правая половинка
//                // Вырезаем правую часть (от 0.5 до 1.0 по ширине)
//                let rightTexture = SKTexture(rect: CGRect(x: 0.5, y: 0, width: 0.5, height: 1.0), in: texture)
//                let rightHalf = SKSpriteNode(texture: rightTexture, size: CGSize(width: size.width / 2, height: size.height))
//                // Магия: сдвигаем точку крепления на левый край
//                rightHalf.anchorPoint = CGPoint(x: 0.0, y: 0.5)
//                rightHalf.position = position
//                rightHalf.zRotation = zRot
//                rightHalf.zPosition = card.zPosition
//                
//                // Добавляем половинки на сцену
//                addChild(leftHalf)
//                addChild(rightHalf)
//                
//                // Сразу прячем целую карту
//                card.removeFromParent()
//                
//                // 3. Анимация падения (Разводим в стороны, крутим и опускаем вниз)
//                let fallDuration = 0.45
//                
//                let flyLeft = SKAction.group([
//                    SKAction.moveBy(x: -80, y: -150, duration: fallDuration),
//                    SKAction.rotate(byAngle: 0.8, duration: fallDuration),
//                    SKAction.fadeOut(withDuration: fallDuration)
//                ])
//                flyLeft.timingMode = .easeOut // Плавное замедление
//                
//                let flyRight = SKAction.group([
//                    SKAction.moveBy(x: 80, y: -150, duration: fallDuration),
//                    SKAction.rotate(byAngle: -0.8, duration: fallDuration),
//                    SKAction.fadeOut(withDuration: fallDuration)
//                ])
//                flyRight.timingMode = .easeOut
//                
//                // Запускаем анимации и удаляем куски, когда они исчезнут
//                leftHalf.run(SKAction.sequence([flyLeft, SKAction.removeFromParent()]))
//                rightHalf.run(SKAction.sequence([flyRight, SKAction.removeFromParent()]))
//                
//            } else {
//                // Запасной вариант (если текстура почему-то не подгрузилась)
//                let scaleUp = SKAction.scale(to: 1.2, duration: 0.05)
//                let fadeOut = SKAction.fadeOut(withDuration: 0.15)
//                card.run(SKAction.sequence([scaleUp, fadeOut, SKAction.removeFromParent()]))
//            }
//            // MARK: - КОНЕЦ АНИМАЦИИ
//            
//            // Всплывающий текст и искры
//            showFloatingText("+10 MTCoins", at: card.position, color: UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1))
//            showSlashParticles(at: card.position)
//            
//            
//        }
    
    
    
    
    
    // ВНИМАНИЕ: Обрати внимание на новые параметры в скобках!
        private func slashCard(_ card: SKSpriteNode, at touchLocation: CGPoint, swipeVector: CGVector) {
            guard card.name == "card" else { return }
            card.name = "slashed"
            card.removeAllActions()
            
            sessionCoins += 10
            sessionCoinsLabel.text = "\(sessionCoins)"
            
            let pop = SKAction.sequence([
                SKAction.scale(to: 1.3, duration: 0.1),
                SKAction.scale(to: 1.0, duration: 0.1)
            ])
            coinIcon.run(pop)
            
            if let texture = card.texture {
                let cardWidth = card.size.width
                let cardHeight = card.size.height
                
                // 1. Узнаем, где именно мы коснулись карты (локальные координаты)
                let locationInCard = convert(touchLocation, to: card)
                
                // 2. Вычисляем процент отсечения (где 0.0 - левый край, 1.0 - правый край)
                var cutPercent = (locationInCard.x + cardWidth / 2) / cardWidth
                // Ограничиваем срез, чтобы не отсекать прозрачные пустые пиксели по краям
                cutPercent = max(0.2, min(0.8, cutPercent))
                
                // 3. Создаем невидимый контейнер, чтобы половинки сохранили угол наклона оригинальной карты
                let container = SKNode()
                container.position = card.position
                container.zRotation = card.zRotation
                container.zPosition = card.zPosition
                addChild(container)
                
                // 4. Вырезаем левую часть
                let leftWidth = cardWidth * cutPercent
                let leftTexture = SKTexture(rect: CGRect(x: 0, y: 0, width: cutPercent, height: 1.0), in: texture)
                let leftHalf = SKSpriteNode(texture: leftTexture, size: CGSize(width: leftWidth, height: cardHeight))
                leftHalf.position = CGPoint(x: (-cardWidth / 2) + (leftWidth / 2), y: 0)
                
                // 5. Вырезаем правую часть
                let rightWidth = cardWidth * (1.0 - cutPercent)
                let rightTexture = SKTexture(rect: CGRect(x: cutPercent, y: 0, width: 1.0 - cutPercent, height: 1.0), in: texture)
                let rightHalf = SKSpriteNode(texture: rightTexture, size: CGSize(width: rightWidth, height: cardHeight))
                rightHalf.position = CGPoint(x: (cardWidth / 2) - (rightWidth / 2), y: 0)
                
                container.addChild(leftHalf)
                container.addChild(rightHalf)
                card.removeFromParent()
                
                // 6. Динамическая физика разлета
                // Нормализуем вектор свайпа (чтобы сила разлета не зависела от скорости пальца)
                let length = max(1.0, sqrt(swipeVector.dx * swipeVector.dx + swipeVector.dy * swipeVector.dy))
                let nx = swipeVector.dx / length
                let ny = swipeVector.dy / length
                
                // Вычисляем перпендикуляр к направлению свайпа для реалистичного разлета
                let force: CGFloat = 120.0
                let leftFlyX = -ny * force
                let leftFlyY = nx * force - 150 // -150 это гравитация вниз
                
                let rightFlyX = ny * force
                let rightFlyY = -nx * force - 150
                
                let fallDuration = 0.5
                
                let flyLeft = SKAction.group([
                    SKAction.moveBy(x: leftFlyX, y: leftFlyY, duration: fallDuration),
                    SKAction.rotate(byAngle: 1.5, duration: fallDuration),
                    SKAction.fadeOut(withDuration: fallDuration)
                ])
                flyLeft.timingMode = .easeOut
                
                let flyRight = SKAction.group([
                    SKAction.moveBy(x: rightFlyX, y: rightFlyY, duration: fallDuration),
                    SKAction.rotate(byAngle: -1.5, duration: fallDuration),
                    SKAction.fadeOut(withDuration: fallDuration)
                ])
                flyRight.timingMode = .easeOut
                
                leftHalf.run(SKAction.sequence([flyLeft, SKAction.removeFromParent()]))
                rightHalf.run(SKAction.sequence([flyRight, SKAction.removeFromParent()]))
                
                // Очищаем контейнер из памяти
                container.run(SKAction.sequence([SKAction.wait(forDuration: fallDuration), SKAction.removeFromParent()]))
                
            } else {
                // Заглушка, если текстура не прогрузилась
                let scaleUp = SKAction.scale(to: 1.2, duration: 0.05)
                let fadeOut = SKAction.fadeOut(withDuration: 0.15)
                card.run(SKAction.sequence([scaleUp, fadeOut, SKAction.removeFromParent()]))
            }
            
            showFloatingText("+10 MTCoins", at: touchLocation, color: UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1))
            showSlashParticles(at: touchLocation)
        }
    
    
    
    
    
    
    
    
    
    
    private func slashBomb(_ bomb: SKNode) {
        guard bomb.name == "bomb" else { return }
        bomb.name = "slashed"
        bomb.removeAllActions()
        lives -= 1
        updateLives()
        
        let shake = SKAction.sequence([
            SKAction.moveBy(x: -10, y: 0, duration: 0.05), SKAction.moveBy(x: 10, y: 0, duration: 0.05),
            SKAction.moveBy(x: -10, y: 0, duration: 0.05), SKAction.moveBy(x: 10, y: 0, duration: 0.05)
        ])
        self.run(shake)
        bomb.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.2), SKAction.removeFromParent()]))
        showFloatingText("-❤️", at: bomb.position, color: UIColor.red)
        
        if lives <= 0 { endGame() }
    }
    
    private func updateLives() {
        livesLabel.text = lives > 0 ? String(repeating: "❤️", count: lives) : "💔"
    }
    
    private func showSlashEffect(at position: CGPoint) {
        let slash = SKShapeNode(circleOfRadius: 4)
        slash.fillColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 0.8) // Синий след
        slash.strokeColor = .clear
        slash.position = position
        slash.zPosition = 3
        addChild(slash)
        slash.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.12), SKAction.removeFromParent()]))
    }
    
    private func showFloatingText(_ text: String, at position: CGPoint, color: UIColor) {
        let label = SKLabelNode(text: text)
        label.fontSize = 24
        label.fontColor = color
        label.position = position
        label.fontName = "AvenirNext-Heavy"
        label.zPosition = 5
        addChild(label)
        label.run(SKAction.sequence([
            SKAction.group([SKAction.moveBy(x: 0, y: 60, duration: 0.6), SKAction.fadeOut(withDuration: 0.6)]),
            SKAction.removeFromParent()
        ]))
    }
    
    private func showSlashParticles(at position: CGPoint) {
        for _ in 0..<8 {
            let particle = SKShapeNode(circleOfRadius: 3)
            particle.fillColor = UIColor(red: 0.35, green: 0.78, blue: 0.98, alpha: 1) // Голубые частицы
            particle.strokeColor = .clear
            particle.position = position
            addChild(particle)
            let randomX = CGFloat.random(in: -60...60)
            let randomY = CGFloat.random(in: -60...60)
            particle.run(SKAction.sequence([
                SKAction.group([SKAction.moveBy(x: randomX, y: randomY, duration: 0.4), SKAction.fadeOut(withDuration: 0.4)]),
                SKAction.removeFromParent()
            ]))
        }
    }
    
    private func endGame() {
        isGameOver = true
        removeAction(forKey: "spawning")
        spawnTimer?.invalidate()
        gameTimer?.invalidate()
        children.filter { $0.name == "card" || $0.name == "bomb" }.forEach { $0.removeFromParent() }
        
        // ВМЕСТО ОТРИСОВКИ ЭКРАНА В SPRITEKIT, ВОЗВРАЩАЕМСЯ В SWIFTUI
        onGameOver?(sessionCoins)
    }
    
    override func willMove(from view: SKView) {
        spawnTimer?.invalidate()
        gameTimer?.invalidate()
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255, opacity: Double(a)/255)
    }
}

//#Preview {
//    CardSlashView()
//}


