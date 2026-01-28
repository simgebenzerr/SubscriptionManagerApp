import UserNotifications
import SwiftUI

class NotificationManager {
    // Diğer sayfalardan rahat ulaşmak için 'instance' kullanıyoruz
    static let instance = NotificationManager()
    
    // 1. İzin İsteme
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error = error {
                print("Hata: \(error.localizedDescription)")
            } else {
                print("Bildirim izni: \(success ? "Verildi" : "Reddedildi")")
            }
        }
    }
    
    // 2. Bildirim Planlama (Fiyat bilgisini de ekledim)
    func scheduleNotification(title: String, date: Date, price: Double) {
        let content = UNMutableNotificationContent()
        content.title = "Ödeme Vakti! 💸"
        content.body = "Yarın \(title) aboneliğinin ödemesi var. Tutar: \(String(format: "%.2f", price)) ₺"
        content.sound = .default
        
        // Seçilen tarihin 1 gün öncesine, sabah 09:00'a ayarla
        var dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: date)
        if let day = dateComponents.day {
            dateComponents.day = day - 1 // 1 gün önce
        }
        dateComponents.hour = 9  // Sabah 09:00
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // ÖNEMLİ: ID olarak 'title' (İsim) kullanıyoruz.
        // Böylece aynı isimli aboneliği düzenlersen eski bildirimin üzerine yazar, çift bildirim olmaz.
        let request = UNNotificationRequest(identifier: title, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        print("\(title) için bildirim kuruldu.")
    }
    
    // İsteğe bağlı: Bildirim iptal etme (Silme işlemi için)
    func cancelNotification(title: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [title])
    }
}
