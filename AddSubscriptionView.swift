import SwiftUI
import SwiftData

struct AddSubscriptionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var subscriptionToEdit: Subscription?

    @State private var name = ""
    @State private var price: Double? = nil
    @State private var currency = "₺"
    @State private var renewalDate = Date()
    @State private var selectedIcon = "creditcard"
    @State private var selectedColor = "007AFF" // Varsayılan Mavi
    @State private var enableNotification = false
    
    // Alttan açılan renk menüsü kontrolü
    @State private var showColorPicker = false
    
    // İkon Listesi
    let icons = ["creditcard", "music.note", "play.tv.fill", "gamecontroller.fill", "book.fill", "icloud.fill", "wifi", "dumbbell.fill", "cart.fill", "car.fill", "house.fill", "airplane", "gift.fill", "star.fill", "heart.fill"]
    
    // Renk Listesi
    let colorOptions: [(name: String, hex: String)] = [
        ("Mavi", "007AFF"),
        ("Kırmızı", "FF3B30"),
        ("Yeşil", "34C759"),
        ("Turuncu", "FF9500"),
        ("Mor", "AF52DE"),
        ("İndigo", "5856D6"),
        ("Pembe", "FF66C4"),
        ("Siyah", "000000"),
        ("Gri", "8E8E93")
    ]

    var body: some View {
        NavigationStack {
            Form {
                // BÖLÜM 1: PLATFORM BİLGİLERİ
                Section(header: Text("Platform Bilgileri")) {
                    TextField("Abonelik Adı (Örn: Netflix)", text: $name)
                    
                    HStack {
                        TextField("Fiyat", value: $price, format: .number)
                            .keyboardType(.decimalPad)
                        
                        Picker("Para Birimi", selection: $currency) {
                            Text("₺").tag("₺")
                            Text("$").tag("$")
                            Text("€").tag("€")
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 100)
                    }
                }
                
                // BÖLÜM 2: ZAMANLAMA
                Section(header: Text("Zamanlama")) {
                    DatePicker("Yenilenme Tarihi", selection: $renewalDate, displayedComponents: .date)
                }
                
                // BÖLÜM 3: GÖRÜNÜM
                Section {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("İkon Seç")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text("Rengi değiştirmek için basılı tut 🎨")
                                .font(.caption2)
                                .fontWeight(.medium)
                                .foregroundStyle(.blue)
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(icons, id: \.self) { icon in
                                    ZStack {
                                        // Seçili olanın arkasına renkli daire
                                        if selectedIcon == icon {
                                            Circle()
                                                .fill(Color(hex: selectedColor)?.opacity(0.2) ?? .blue.opacity(0.2))
                                                .frame(width: 50, height: 50)
                                        }
                                        
                                        Image(systemName: icon)
                                            .font(.title2)
                                            .foregroundColor(selectedIcon == icon ? Color(hex: selectedColor) : .gray)
                                            .frame(width: 50, height: 50)
                                            .background(Color.white.opacity(0.01)) // Tıklama alanını doldurur
                                            
                                            // 1. TIKLAMA: Sadece ikonu seçer
                                            .onTapGesture {
                                                withAnimation { selectedIcon = icon }
                                            }
                                            
                                            // 2. BASILI TUTMA: Renk menüsünü açar
                                            .onLongPressGesture {
                                                withAnimation { selectedIcon = icon }
                                                showColorPicker = true
                                            }
                                    }
                                }
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .padding(.vertical, 5)
                } header: {
                    Text("Görünüm")
                }
                
                // BÖLÜM 4: HATIRLATICI
                Section(header: Text("Hatırlatıcı")) {
                    Toggle("Ödeme Günü Bildirim Gönder", isOn: $enableNotification)
                        .onChange(of: enableNotification) { oldValue, newValue in
                            if newValue {
                                NotificationManager.instance.requestAuthorization()
                            }
                        }
                }
            }
            .navigationTitle(subscriptionToEdit == nil ? "Yeni Abonelik" : "Düzenle")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Vazgeç") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Kaydet") {
                        saveSubscription()
                    }
                    .disabled(name.isEmpty || price == nil)
                }
            }
            // ✅ YARIM EKRAN RENK MENÜSÜ (Sheet)
            .sheet(isPresented: $showColorPicker) {
                VStack(spacing: 20) {
                    Capsule()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 40, height: 5)
                        .padding(.top, 10)
                    
                    Text("İkon Rengini Seç")
                        .font(.headline)
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 20) {
                        ForEach(colorOptions, id: \.hex) { option in
                            VStack {
                                Circle()
                                    .fill(Color(hex: option.hex) ?? .blue)
                                    .frame(width: 50, height: 50)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.primary, lineWidth: selectedColor == option.hex ? 3 : 0)
                                    )
                                    .onTapGesture {
                                        selectedColor = option.hex
                                        showColorPicker = false // Seçince kapat
                                    }
                                
                                Text(option.name)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding()
                    Spacer()
                }
                .presentationDetents([.height(350)]) // Yüksekliği sınırladık
                .presentationDragIndicator(.visible)
            }
            .onAppear {
                if let sub = subscriptionToEdit {
                    name = sub.name
                    price = sub.price
                    currency = sub.currency
                    renewalDate = sub.renewalDate
                    selectedIcon = sub.icon
                    selectedColor = sub.colorHex
                }
            }
        }
    }

    private func saveSubscription() {
        if let sub = subscriptionToEdit {
            sub.name = name
            sub.price = price ?? 0.0
            sub.currency = currency
            sub.renewalDate = renewalDate
            sub.icon = selectedIcon
            sub.colorHex = selectedColor
        } else {
            let newSubscription = Subscription(
                name: name,
                price: price ?? 0.0,
                renewalDate: renewalDate,
                icon: selectedIcon,
                colorHex: selectedColor
            )
            newSubscription.currency = currency
            modelContext.insert(newSubscription)
        }
        
        if enableNotification {
            NotificationManager.instance.scheduleNotification(
                title: name,
                date: renewalDate,
                price: price ?? 0.0
            )
        } else {
            NotificationManager.instance.cancelNotification(title: name)
        }
        
        dismiss()
    }
}

#Preview {
    AddSubscriptionView()
}
