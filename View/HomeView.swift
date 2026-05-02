
import SwiftUI

struct HomeView: View {
    @StateObject private var vm = HomeViewModel()
    @State private var selectedCardIndex = 0
    
    var body: some View {
        ZStack {
            Color.appBg.ignoresSafeArea(edges: .all)
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    headerSection
                        .padding(.top, 20)
                    cardSection
                        .padding(.top, 30)
                    balanceSection
                        .padding(.top, 20)
                    quickActionSection
                        .padding(.top, 20)
                }
            }
        }
    }
    
    var headerSection: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Welcome 👋")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.appTextSub)
                Text(vm.userName)
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.appTextSub)
            }
            .padding(.top, 20)
            .padding(.leading, 20)
            Spacer()
            
            ZStack {
                Circle()
                    .fill(LinearGradient.goldGradient)
                    .frame(width: 60, height: 60)
                Image("musk")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 55, height: 55)
                    .clipShape(Circle())
                    
            }
            .padding(.top, 20)
            .padding(.trailing, 20)
        }
        .padding(.horizontal, 7)
    }
    
    var cardSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("My Cards")
                .padding(.leading, 20)
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.appText)
            
            if !vm.cards.isEmpty {
                TabView(selection: $selectedCardIndex) {
                    ForEach(vm.cards.indices, id: \.self) { index in
                        CardView(card: vm.cards[index])
                            .tag(index)
                            .scaleEffect(selectedCardIndex == index ? 1.0 : 0.9)
                            .opacity(selectedCardIndex == index ? 1.0 : 0.7)
                            .padding(.vertical)
                            .padding(.horizontal, 10)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 260)
                .animation(.spring(response: 0.4, dampingFraction: 0.7, blendDuration: 0.5), value: selectedCardIndex)
                
                
                HStack(spacing: 6) {
                    ForEach(0..<vm.cards.count, id: \.self) { index in
                        Capsule()
                            .fill(selectedCardIndex == index ? LinearGradient.goldGradient : LinearGradient(colors: [Color.appSurface2], startPoint: .leading, endPoint: .trailing))
                            .frame(width: selectedCardIndex == index ? 20 : 6, height: 6)
                            .animation(.spring(duration: 0.3), value: selectedCardIndex)
                    }
                }
                .frame(maxWidth: .infinity)
                
            } else {
                Text("You haven't got some cards yet")
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundStyle(Color.appTextSub)
                    .padding(.leading, 20)
            }
            
            
        }
    }
    
    var balanceSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Text("Total balance")
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .foregroundStyle(Color.appTextSub)
                .padding(.leading, 20)
            
            HStack(alignment: .firstTextBaseline) {
                Text("$")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.appGold)
                Text("\(vm.totalBalance, specifier: "%.2f")")
                    .font(.system(size: 42, weight: .bold, design: .monospaced))
                    .foregroundStyle(Color.appText)
            }
            .padding(.leading, 20)
            .padding(.top, 5)
        }
    }
    
    var quickActionSection: some View {
        VStack(alignment: .leading) {
            Text("Quick actions")
                .padding(.leading, 20)
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.appText)
            
            HStack(spacing: 10) {
                QuickActionButton(icon: "paperplane.fill", title: "Send") {}
                QuickActionButton(icon: "creditcard.fill", title: "Pay") {}
                QuickActionButton(icon: "plus.circle.fill", title: "Top Up") {}
                QuickActionButton(icon: "ellipsis.circle.fill", title: "More") {}
            }
            .padding(.horizontal, 20)
        }
    }
    
    
    

    
    
    
}

struct QuickActionButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.appSurface1)
                        .frame(width: 55, height: 55)
                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundStyle(LinearGradient.goldGradient)
                }
                
                Text(title)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.appTextSub)
                
            }
        }
        .frame(maxWidth: .infinity)
    }
}






#Preview {
    HomeView()
}
