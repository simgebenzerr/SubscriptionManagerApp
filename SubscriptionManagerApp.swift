import SwiftUI
import SwiftData

@main
struct SubscriptionManagerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // İşte sihirli dokunuş burası: Veri tabanını tüm uygulamaya tanıtıyoruz
        .modelContainer(for: Subscription.self)
    }
}
