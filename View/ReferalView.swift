import UIKit
import SwiftUI
import CoreImage.CIFilterBuiltins // Нужно для генерации QR-кода

// MARK: - Экран Реферальной Системы
struct ReferralView: View {
    @Binding var isPresented: Bool
    
    // В реальном приложении ссылка должна быть уникальной для каждого юзера,
    // например: "https://spiritbank.app/invite/\(userId)"
    let inviteLink = "https://spiritbank.app/invite/alex123"
    
    @State private var isCopied = false
    
    var body: some View {
        ZStack {
            Color.appBg.ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Заголовок
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
                    Text("Invite Friends")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.appText)
                    Spacer()
                    // Невидимая кнопка для симметрии
                    Color.clear.frame(width: 36, height: 36)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                // Главный оффер
                VStack(spacing: 12) {
                    Text("🎁")
                        .font(.system(size: 60))
                    
                    Text("Get 1 Free Spin")
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundStyle(Color.appText)
                    
                    Text("For you and your friend when they join Spirit Bank using your link.")
                        .font(.system(size: 15))
                        .foregroundStyle(Color.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                // QR Код
                VStack {
                    Image(uiImage: generateQRCode(from: inviteLink))
                        .interpolation(.none) // Чтобы QR был четким, а не размытым
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 180)
                        .padding(20)
                        .background(Color.white) // QR код лучше читается на белом фоне
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                    
                    Text("Scan to join")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.gray)
                        .padding(.top, 8)
                }
                
                // Блок с ссылкой
                HStack {
                    Text(inviteLink)
                        .font(.system(size: 14, design: .monospaced))
                        .foregroundStyle(Color.appText)
                        .lineLimit(1)
                        .truncationMode(.middle)
                    
                    Spacer()
                    
                    Button {
                        UIPasteboard.general.string = inviteLink
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                        
                        withAnimation {
                            isCopied = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation { isCopied = false }
                        }
                    } label: {
                        Text(isCopied ? "Copied!" : "Copy")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(isCopied ? Color.green : Color(hex: "#007AFF"))
                            .clipShape(Capsule())
                    }
                }
                .padding(16)
                .background(Color.appSurface1)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 24)
                
                // Кнопка Share (вызывает системное меню поделиться)
                Button {
                    shareLink()
                } label: {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Share Link")
                    }
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(LinearGradient(colors: [Color(hex: "#5AC8FA"), Color(hex: "#007AFF")], startPoint: .leading, endPoint: .trailing))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
                
                Spacer()
            }
        }
    }
    
    // Функция генерации QR-кода
    func generateQRCode(from string: String) -> UIImage {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            // Увеличиваем четкость картинки
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let scaledImage = outputImage.transformed(by: transform)
            
            if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    // Функция вызова системного меню "Поделиться"
    func shareLink() {
        let textToShare = "Join me on Spirit Bank and let's both get a Free Spin! 🎰 \(inviteLink)"
        let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        
        // Для iPad требуется указать источник
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            
            activityViewController.popoverPresentationController?.sourceView = window
            rootVC.present(activityViewController, animated: true, completion: nil)
        }
    }
}
