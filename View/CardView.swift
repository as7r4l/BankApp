
import SwiftUI

struct CardView: View {
    let card: Card
    var body: some View {
        ZStack {
            Image(card.style.imageName)
                .resizable()
                .scaledToFill()
            VStack(alignment: .leading, spacing: 0) {
                
                Spacer()
                HStack {
                    Text(card.holderName)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(card.style.textColor)
                        .padding(.trailing, 20)
                    Text(card.expiryDate)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(card.style.textColor.opacity(0.8))
                }
                HStack {
                    Text(card.number)
                        .font(.system(size: 20, weight: .bold, design: .monospaced))
                        .foregroundStyle(card.style.textColor)
                    Spacer()
                }
            }
            .padding(.leading, 15)
            .padding(.bottom, 15)
        }
        .frame(height: 242)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}


//#Preview {
//    let card = Card()
//    card.holderName = "JOHN SMITH"
//    card.number = "0000 0000 0000 0000"
//    card.expiryDate = "10/25"
//    card.style = .dark
//    
//    CardView(card: card)
//        .padding()
//        .background(Color.appBg)
//}
