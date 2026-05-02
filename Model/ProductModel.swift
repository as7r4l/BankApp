import Foundation

struct ProductCardInfo: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let imageName: String // Названия картинок из твоих Assets
    let features: [String]
    let style: CardStyle
}

// Заглушки данных на основе твоих скриншотов
let sampleProducts: [ProductCardInfo] = [
    
    ProductCardInfo(
        title: "Карта Slash",
        subtitle: "Топ-карты, Базовые, Виртуальные карты",
        imageName: "slash",
        features: [
            "5 BYN/мес",
            """
            Бесплатное обслуживание при:
            🔄 оборот ≥400 BYN/мес
            🎮 20 дней игры в месяц
            🏦 депозит ≥200 BYN
            """,
            "Реальный кешбэк с игры"
        ],
        style: .mt
    ),
    
    ProductCardInfo(
        title: "МТкарта",
        subtitle: "Топ-карты, Базовые, Для шопинга, Валютные",
        imageName: "mt",
        features: [
            "Бесплатные карты в BYN, USD, EUR",
            "Снятие наличных без комиссии до 1000 BYN в месяц",
            "Возврат до 10% МТбаллами с Пакетом Лайт"
        ],
        style: .mt
    ),
    ProductCardInfo(
        title: "Халва",
        subtitle: "Топ-карты, Халва, Для шопинга",
        imageName: "halva",
        features: [
            "Рассрочка до 12-ти месяцев без переплат у партнёров",
            "Лимит до 10 000 BYN на все покупки и оплаты по карте",
            "Оплачивайте покупки частями до 24-х месяцев в любых магазинах"
        ],
        style: .halva
    ),
    ProductCardInfo(
        title: "Onliner Клевер",
        subtitle: "Топ-карты, Цифровые, Базовые, Для шопинга",
        imageName: "clever",
        features: [
            "5% возврат на покупки в Каталоге Onliner",
            "1% возврат на любые покупки вне Каталога Onliner",
            "Мгновенное и бесплатное оформление"
        ],
        style: .clever
    ),
    
    
    ]
