import SwiftUI
import SwiftData

struct ContentView: View {
    // Gece/Gündüz ayarı (Tüm uygulama için)
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        // ALT MENÜ (TAB BAR)
        TabView {
            // 1. Sekme: Ana Liste
            HomeView(isDarkMode: $isDarkMode)
                .tabItem {
                    Label("Abonelikler", systemImage: "list.bullet.rectangle.portrait")
                }
            
            // 2. Sekme: Grafikler
            AnalysisView()
                .tabItem {
                    Label("Analiz", systemImage: "chart.pie.fill")
                }
        }
        // Tüm uygulamanın renk modunu buradan yönetiyoruz
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

// ANA LİSTE EKRANI
struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Subscription.renewalDate, order: .forward) private var subscriptions: [Subscription]
    @Binding var isDarkMode: Bool
    
    // ✅ YENİ: Hangi aboneliği düzenleyeceğiz?
    @State private var selectedSubscription: Subscription?
    // Yeni ekleme sayfası için
    @State private var showingAddSheet = false

    // ✅ SİLME FONKSİYONU (Bildirim iptali de eklendi)
    func deleteSubscription(at offsets: IndexSet) {
        for index in offsets {
            let subscription = subscriptions[index]
            // Silmeden önce bildirimini iptal et
            NotificationManager.instance.cancelNotification(title: subscription.name)
            modelContext.delete(subscription)
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Arka plan rengi
                Color(uiColor: isDarkMode ? .black : .systemGroupedBackground)
                    .ignoresSafeArea()
                
                if subscriptions.isEmpty {
                    ContentUnavailableView(
                        "Hiç Abonelik Yok",
                        systemImage: "creditcard.and.123",
                        description: Text("Sağ üstteki + butonuna basarak ekle.")
                    )
                } else {
                    // SCROLLVIEW YERİNE LIST
                    List {
                        ForEach(subscriptions) { subscription in
                            SubscriptionRow(subscription: subscription, isDarkMode: isDarkMode)
                                // Tasarımı korumak için liste çizgilerini gizliyoruz
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                                
                                // ✅ 1. TIKLAYINCA DÜZENLEME (Pratik olsun diye)
                                .onTapGesture {
                                    selectedSubscription = subscription
                                }
                                
                                // ✅ 2. SAĞA KAYDIRINCA DÜZENLEME (İstediğin Özellik)
                                .swipeActions(edge: .leading) { // Leading = Sol Kenar (Sağa çekince)
                                    Button {
                                        selectedSubscription = subscription
                                    } label: {
                                        Label("Düzenle Ed", systemImage: "pencil")
                                    }
                                    .tint(.blue) // Mavi renk
                                }
                        }
                        .onDelete(perform: deleteSubscription) // 👈 SOLA KAYDIR SİL
                    }
                    .listStyle(.plain) // Sade liste görünümü
                    .scrollContentBackground(.hidden) // Listenin gri arka planını kaldır
                }
            }
            .navigationTitle("Abonelik Takip")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { withAnimation { isDarkMode.toggle() } }) {
                        Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                            .font(.system(size: 22))
                            .foregroundStyle(isDarkMode ? .yellow : .orange)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingAddSheet = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(.blue)
                    }
                }
            }
            // 1. DURUM: Yeni Ekleme
            .sheet(isPresented: $showingAddSheet) {
                AddSubscriptionView(subscriptionToEdit: nil)
                    .presentationDetents([.medium, .large])
            }
            // 2. DURUM: Düzenleme (Bu kısım eksikti, ekledim)
            .sheet(item: $selectedSubscription) { subscription in
                AddSubscriptionView(subscriptionToEdit: subscription)
                    .presentationDetents([.medium, .large])
            }
        }
    }
}

// KART TASARIMI (Senin tasarımın aynen duruyor)
struct SubscriptionRow: View {
    let subscription: Subscription
    var isDarkMode: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color(hex: subscription.colorHex)?.opacity(0.2) ?? .gray.opacity(0.2))
                    .frame(width: 50, height: 50)
                Image(systemName: subscription.icon)
                    .font(.system(size: 24))
                    .foregroundColor(Color(hex: subscription.colorHex) ?? .blue)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(subscription.name)
                    .font(.headline)
                    .foregroundStyle(isDarkMode ? .white : .black)
                Text(subscription.renewalDate.formatted(date: .numeric, time: .omitted))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text("\(String(format: "%.2f", subscription.price)) \(subscription.currency)")
                .fontWeight(.bold)
                .foregroundStyle(isDarkMode ? .white : .black)
        }
        .padding()
        .background(isDarkMode ? Color(uiColor: .secondarySystemGroupedBackground) : Color.white)
        .cornerRadius(16)
        .shadow(color: isDarkMode ? .clear : .black.opacity(0.1), radius: 5)
        .padding(.horizontal) // Kenar boşlukları
        .contentShape(Rectangle()) // Tıklanabilir alanı düzeltir
    }
}

// RENK YARDIMCISI
extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        self.init(.sRGB, red: Double((rgb & 0xFF0000) >> 16) / 255.0, green: Double((rgb & 0x00FF00) >> 8) / 255.0, blue: Double(rgb & 0x0000FF) / 255.0, opacity: 1.0)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Subscription.self, inMemory: true)
}
