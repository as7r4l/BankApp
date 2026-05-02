import SwiftUI

struct AuthTextField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 7) {
           Text(label)
                .foregroundStyle(Color.appTextSub)
                .font(Font.caption.bold())
                .textCase(.uppercase)
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                        .padding(7)
                        .foregroundStyle(Color.appText)
                } else {
                    TextField(placeholder, text: $text)
                        .padding(7)
                        .foregroundStyle(Color.appText)
                }
            }
            .focused($isFocused)
            .padding(10)
            .background(Color.appSurface1)
            .foregroundStyle(Color.appText)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(
                        isFocused || !text.isEmpty ? Color.appGold.opacity(0.8) : Color.appSurface2,
                        lineWidth: 1
                    )
                )
            .animation(.linear(duration: 0.5), value: isFocused)
        }
        .padding(.horizontal, 15)
        
    }
}


struct AuthView: View {
    @StateObject private var vm = AuthViewModel()
    var onAuthSuccess: () -> Void
    var body: some View {
        ZStack {
            Color.appBg.edgesIgnoringSafeArea(.all)
            
            if vm.isDone {
                successView
                
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        logo
                            .padding(.top, 70)
                        formSwitch
                            .padding()
                        form
                           
                    }
                    
                }
            }
        }
    }
    
    var logo: some View {
        VStack(spacing: 15) {
            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .frame(width: 60, height: 60)
                    .foregroundStyle(Color.gold)
                Text("S")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.appBg)
            }
            
            Text("SPIRIT")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(Color.appText)
            
            Text(vm.isLogin ? "Sign in acount" : "Create new acount")
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundStyle(Color.appTextMuted)
        }
    }
    
    var formSwitch: some View {
        HStack {
            ForEach(["Sign In", "Sign up"], id: \.self) { (tab: String) in
                let isActive: Bool = tab == (vm.isLogin ? "Sign In" : "Sign up")
                Button(action: {
                    withAnimation(.spring(duration: 0.5)) {
                        vm.isLogin = tab == "Sign In"
                        vm.errorMessage = ""
                    }
                    
                }) {
                    Text(tab)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(isActive ? Color.appBg : Color.appTextMuted)
                        .background(isActive ? AnyView(LinearGradient.goldGradient) : AnyView(Color.clear))
                        .clipShape(Capsule())
                        
                }
                
            }
        }
        .padding(4)
        .background(Color.appSurface1)
        .clipShape(Capsule())
        
    }
    
    var form: some View {
        VStack(spacing: 15) {
            
            if !vm.isLogin {
                AuthTextField(label: "name", placeholder: "John Smith", text: $vm.name)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
            
            AuthTextField(label: "email", placeholder: "email@example.com", text: $vm.email)
            AuthTextField(label: "password", placeholder: "Minimum 6 characters", text: $vm.password, isSecure: true)
            
            
            if !vm.errorMessage.isEmpty {
                HStack(spacing: 5) {
                    Image(systemName: "exclamationmark.triangle.fill")
                    Text(vm.errorMessage)
                        .font(.system(size: 13))
                }
                .foregroundStyle(Color.appError)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.appError.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding(.horizontal)
            }
            
            
            
            
            
            
            GoldButton(title: vm.isLogin ? "Sign in" : "Create acount") {
                vm.submit()
            }
            .padding(.horizontal)
            .padding(.top)
            
            if vm.isLogin {
                Button(action: {
                    //
                }) {
                    Text("Forgot password?")
                        .foregroundStyle(Color.appTextSub)
                        .font(.system(size: 13))
                }
            }
        }
    }
    
    //MARK: Success
    var successView: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(LinearGradient.goldGradient)
                    .frame(width: 72, height: 72)
                Image(systemName: "checkmark")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(Color.appBg)
            }
            Text(vm.isLogin ? "Welcome!" : "Account created!")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(Color.appText)
            Text("Go to the main screen...")
                .font(.system(size: 14))
                .foregroundStyle(Color.appTextSub)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                onAuthSuccess()
            }
        }
    }
}

#Preview {
    AuthView(onAuthSuccess: {})
}
