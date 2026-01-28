import Foundation
import SwiftData

@Model
final class Subscription {
    var name: String
    var price: Double
    var currency: String // TL, USD, EUR
    var renewalDate: Date
    var icon: String // SF Symbol ismi (örn: "music.note", "tv")
    var colorHex: String // Kartın rengi için
    
    init(name: String, price: Double, currency: String = "₺", renewalDate: Date, icon: String = "creditcard", colorHex: String = "007AFF") {
        self.name = name
        self.price = price
        self.currency = currency
        self.renewalDate = renewalDate
        self.icon = icon
        self.colorHex = colorHex
    }
}
