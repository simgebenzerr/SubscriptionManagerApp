Subscription Hunter 
Subscription Hunter, dijital aboneliklerin finansal yönetimini optimize etmek amacıyla geliştirilmiş, SwiftUI ve SwiftData tabanlı bir iOS verimlilik uygulamasıdır. Yazılım mimarisi, yüksek performanslı veri kalıcılığı ve reaktif kullanıcı arayüzü prensipleri üzerine inşa edilmiştir.


<p align="center">
  <img src="https://github.com/user-attachments/assets/cab2d0ef-cacc-4ae1-80b1-ca9d808db448" width="180" alt="Home Screen" />
  <img src="https://github.com/user-attachments/assets/686a914d-ae5d-4923-8aaa-7e7d9361e142" width="180" alt="Analytics View" />
  <img src="https://github.com/user-attachments/assets/6fee42b7-49b0-464d-aa95-4e9734444980" width="180" alt="Add Expense" />
</p>
<p align="center">
  <img src="https://github.com/user-attachments/assets/91ceb661-19b0-4fe0-8023-65feda02896a" width="180" alt="Edit Salary" />
  <img src="https://github.com/user-attachments/assets/d3cfc37a-50c0-47d8-be05-c899d20fd9d8" width="180" alt="Dark Mode" />
</p>

Teknik Mimari ve Stack
Uygulama, modern iOS ekosistemindeki en güncel teknolojiler kullanılarak geliştirilmiştir:

UI Framework: Deklaratif tasarım yaklaşımı ile SwiftUI.

Persistency Layer: Veri modellerinin yerel olarak saklanması ve yönetilmesi için yeni nesil SwiftData framework'ü.

Architecture: Kod sürdürülebilirliği ve test edilebilirliği için MVVM tasarım kalıbı.

Local Notifications: Ödeme döngülerinin takibi için UserNotifications entegrasyonu.

 Öne Çıkan Özellikler
Dynamic UX: Kullanıcıların her abonelik için özelleştirilmiş SFSymbols ikonları ve renk paletleri atayabilmesini sağlayan esnek arayüz.

Advanced Interaction: Akıcı bir kullanıcı deneyimi için sağa kaydırma ile Edit (Düzenleme) ve sola kaydırma ile Delete (Silme) fonksiyonlarını destekleyen SwipeActions mimarisi.

Smart Scheduling: Abonelik yenilenme tarihlerine göre otomatik olarak planlanan yerel bildirimler.

Contextual UI: İkon renklerinin dinamik olarak değiştirilmesi için kurgulanmış profesyonel ContextMenu ve Sheet tabanlı renk seçim sistemleri.

Dark Mode Support: @AppStorage kullanılarak tüm uygulama genelinde senkronize edilen dinamik renk teması yönetimi.

Proje Yapısı
├── SubscriptionManager/
│   ├── AddSubscriptionView.swift  # Veri giriş ve düzenleme mantığı
│   ├── AnalysisView.swift         # Finansal veri analiz ekranı
│   ├── ContentView.swift          # Ana liste ve navigasyon hiyerarşisi
│   ├── NotificationManager.swift  # Bildirim zamanlama motoru
│   ├── Subscription.swift         # SwiftData model tanımı

Kurulum

Repoyu klonlayın: git clone https://github.com/simgebenzerr/SubscriptionManagerApp.git.

SubscriptionManager.xcodeproj dosyasını Xcode ile açın.

Target olarak iOS 17.0+ seçili olduğundan emin olun ve Run edin.
