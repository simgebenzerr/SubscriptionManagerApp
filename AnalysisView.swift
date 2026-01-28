import SwiftUI
import SwiftData
import Charts

struct AnalysisView: View {
    @Query private var subscriptions: [Subscription]
    
    var body: some View {
        NavigationStack {
            VStack {
                if subscriptions.isEmpty {
                    ContentUnavailableView(
                        "Veri Yok",
                        systemImage: "chart.pie",
                        description: Text("Grafik görmek için önce abonelik ekle.")
                    )
                } else {
                    // GRAFİK ALANI
                    Chart(subscriptions) { subscription in
                        SectorMark(
                            angle: .value("Fiyat", subscription.price),
                            innerRadius: .ratio(0.6),
                            angularInset: 2
                        )
                        .foregroundStyle(Color(hex: subscription.colorHex) ?? .blue)
                        .cornerRadius(5)
                        .annotation(position: .overlay) {
                            if subscription.price > 0 {
                                Text("\(Int(subscription.price))")
                                    .font(.caption2)
                                    .foregroundStyle(.white)
                                    .bold()
                            }
                        }
                    }
                    .frame(height: 300)
                    .padding()
                    
                    // TOPLAM TUTAR
                    VStack {
                        Text("Toplam Aylık Gider")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        let total = subscriptions.reduce(0) { $0 + $1.price }
                        Text("\(String(format: "%.2f", total)) ₺")
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                    }
                    .padding(.top, -180)
                    .padding(.bottom, 150)
                    
                    // LİSTE DETAYI
                    List {
                        ForEach(subscriptions) { sub in
                            HStack {
                                Circle()
                                    .fill(Color(hex: sub.colorHex) ?? .blue)
                                    .frame(width: 10, height: 10)
                                Text(sub.name)
                                Spacer()
                                Text("\(String(format: "%.2f", sub.price)) \(sub.currency)")
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Analiz")
        }
    }
}

#Preview {
    AnalysisView()
        .modelContainer(for: Subscription.self, inMemory: true)
}
