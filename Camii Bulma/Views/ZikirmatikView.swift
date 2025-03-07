import SwiftUI

struct ZikirmatikView: View {
    @State private var count = 0
    @State private var target = 33
    @State private var showTargetPicker = false
    @State private var showDhikrPicker = false
    @State private var lastVibrationTime = Date()
    @State private var showResetAlert = false
    @State private var selectedDhikr = DhikrType.commonDhikrs[0]
    
    private let vibrationInterval: TimeInterval = 0.1
    
    var body: some View {
        ZStack {
            AppTheme.gradientBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    // Seçili Zikir Bilgisi
                    VStack(spacing: 15) {
                        Text(selectedDhikr.arabic)
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(selectedDhikr.turkish)
                            .font(.system(size: 24))
                            .foregroundColor(.white.opacity(0.9))
                        
                        Text(selectedDhikr.meaning)
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Text("Okunuşu: \(selectedDhikr.pronunciation)")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.top, 30)
                    
                    // Sayaç
                    VStack(spacing: 10) {
                        Text("\(count)")
                            .font(.system(size: 72, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("/ \(target)")
                            .font(.system(size: 24))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    // Zikir Düğmesi
                    Button(action: {
                        incrementCount()
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.15))
                                .frame(width: 200, height: 200)
                                .shadow(color: .white.opacity(0.1), radius: 10)
                            
                            Circle()
                                .stroke(Color.white.opacity(0.3), lineWidth: 2)
                                .frame(width: 200, height: 200)
                            
                            Image(systemName: "rosette")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.white)
                        }
                    }
                    
                    // Kontrol Düğmeleri
                    HStack(spacing: 50) {
                        // Zikir Seçimi
                        Button(action: {
                            showDhikrPicker = true
                        }) {
                            VStack {
                                Image(systemName: "text.book.closed")
                                    .font(.system(size: 24))
                                Text("Zikir")
                                    .font(.system(size: 12))
                            }
                            .foregroundColor(.white)
                        }
                        
                        // Hedef Sayı
                        Button(action: {
                            showTargetPicker = true
                        }) {
                            VStack {
                                Image(systemName: "target")
                                    .font(.system(size: 24))
                                Text("Hedef")
                                    .font(.system(size: 12))
                            }
                            .foregroundColor(.white)
                        }
                        
                        // Sıfırla
                        Button(action: {
                            showResetAlert = true
                        }) {
                            VStack {
                                Image(systemName: "arrow.counterclockwise")
                                    .font(.system(size: 24))
                                Text("Sıfırla")
                                    .font(.system(size: 12))
                            }
                            .foregroundColor(.white)
                        }
                    }
                    .padding(.bottom, 30)
                }
            }
        }
        .navigationTitle("Zikirmatik")
        .sheet(isPresented: $showDhikrPicker) {
            NavigationView {
                ZStack {
                    AppTheme.gradientBackground
                        .ignoresSafeArea()
                    
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(DhikrType.commonDhikrs) { dhikr in
                                Button(action: {
                                    selectedDhikr = dhikr
                                    target = dhikr.recommendedCount
                                    count = 0
                                    showDhikrPicker = false
                                }) {
                                    VStack(alignment: .leading, spacing: 12) {
                                        HStack {
                                            Text(dhikr.turkish)
                                                .font(.title3)
                                                .bold()
                                                .foregroundColor(.white)
                                            Spacer()
                                            if selectedDhikr.id == dhikr.id {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(.white)
                                            }
                                        }
                                        
                                        Text(dhikr.arabic)
                                            .font(.title2)
                                            .foregroundColor(.white.opacity(0.9))
                                        
                                        Text(dhikr.meaning)
                                            .font(.subheadline)
                                            .foregroundColor(.white.opacity(0.8))
                                        
                                        HStack {
                                            Text("Okunuşu: \(dhikr.pronunciation)")
                                                .font(.caption)
                                                .foregroundColor(.white.opacity(0.7))
                                            Spacer()
                                            Text("Önerilen: \(dhikr.recommendedCount)")
                                                .font(.caption)
                                                .foregroundColor(.white.opacity(0.7))
                                        }
                                    }
                                    .padding()
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(15)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                    }
                }
                .navigationTitle("Zikir Seçimi")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Kapat") {
                            showDhikrPicker = false
                        }
                        .foregroundColor(.white)
                    }
                }
            }
            .preferredColorScheme(.dark)
        }
        .sheet(isPresented: $showTargetPicker) {
            NavigationView {
                ZStack {
                    AppTheme.gradientBackground
                        .ignoresSafeArea()
                    
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            ForEach([33, 99, 100, 500, 1000, 1100, 3000, 5000], id: \.self) { number in
                                Button(action: {
                                    target = number
                                    showTargetPicker = false
                                }) {
                                    VStack(spacing: 8) {
                                        Text("\(number)")
                                            .font(.system(size: 32, weight: .bold))
                                            .foregroundColor(.white)
                                        
                                        if target == number {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.white)
                                                .font(.system(size: 24))
                                        } else {
                                            Text("kere")
                                                .font(.system(size: 14))
                                                .foregroundColor(.white.opacity(0.7))
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 100)
                                    .background(
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(Color.white.opacity(target == number ? 0.2 : 0.1))
                                    )
                                }
                            }
                        }
                        .padding()
                    }
                }
                .navigationTitle("Hedef Sayı")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Kapat") {
                            showTargetPicker = false
                        }
                        .foregroundColor(.white)
                    }
                }
            }
            .preferredColorScheme(.dark)
        }
        .alert("Sıfırla", isPresented: $showResetAlert) {
            Button("İptal", role: .cancel) { }
            Button("Sıfırla", role: .destructive) {
                count = 0
            }
        } message: {
            Text("Zikir sayacını sıfırlamak istediğinize emin misiniz?")
        }
    }
    
    private func incrementCount() {
        count += 1
        
        // Titreşim ver
        let now = Date()
        if now.timeIntervalSince(lastVibrationTime) >= vibrationInterval {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            lastVibrationTime = now
        }
        
        // Hedefe ulaşıldığında bildirim
        if count == target {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
    }
}
