import SwiftUI

struct ControlButton: View {
    let imageName: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: imageName)
                    .font(.system(size: 24))
                Text(title)
                    .font(.system(size: 12))
            }
            .foregroundColor(.white)
        }
    }
}

struct RecordListView: View {
    @ObservedObject var viewModel: ZikirViewModel
    @Binding var showingRecords: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.gradientBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // İstatistikler
                    VStack(spacing: 15) {
                        HStack {
                            Text("Toplam Zikir")
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(viewModel.statistics.totalCount)")
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                        HStack {
                            Text("Bugün")
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(viewModel.statistics.dailyCount)")
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                        HStack {
                            Text("Bu Hafta")
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(viewModel.statistics.weeklyCount)")
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                        HStack {
                            Text("Bu Ay")
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(viewModel.statistics.monthlyCount)")
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(15)
                    .padding(.horizontal)
                    
                    // Kayıtlar
                    List {
                        ForEach(viewModel.records.reversed()) { record in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(record.name)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text(record.date.formatted(date: .abbreviated, time: .shortened))
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                
                                Text(record.arabic)
                                    .font(.title3)
                                    .foregroundColor(.white)
                                
                                HStack {
                                    Text("\(record.count)/\(record.target)")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                    
                                    if record.count >= record.target {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                    }
                                }
                            }
                            .padding(.vertical, 5)
                            .listRowBackground(Color.white.opacity(0.1))
                        }
                        .onDelete { indexSet in
                            let reversedRecords = Array(viewModel.records.reversed())
                            for index in indexSet {
                                let record = reversedRecords[index]
                                if let originalIndex = viewModel.records.firstIndex(where: { $0.id == record.id }) {
                                    viewModel.records.remove(at: originalIndex)
                                }
                            }
                            viewModel.saveRecords()
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Zikir Kayıtları")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Kapat") {
                showingRecords = false
            })
            .preferredColorScheme(.dark)
        }
    }
}

struct ZikirmatikView: View {
    @StateObject private var viewModel = ZikirViewModel()
    @State private var showDhikrPicker = false
    @State private var showTargetPicker = false
    @State private var showSaveAlert = false
    @State private var showingRecords = false
    @State private var selectedDhikr = DhikrType.commonDhikrs[0]
    @State private var target: Int = 33
    @State private var lastVibrationTime = Date()
    private let vibrationInterval: TimeInterval = 0.1
    
    var body: some View {
        ZStack {
            AppTheme.gradientBackground
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        showingRecords = true
                    }) {
                        Image(systemName: "list.bullet")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .padding()
                }
                
                Spacer()
                
                // Seçili Zikir
                VStack(spacing: 20) {
                    Text(selectedDhikr.arabic)
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, -30)
                    
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
                .padding(.top, -20)
                
                // Sayaç
                VStack(spacing: 10) {
                    Text("\(viewModel.count)")
                        .font(.system(size: 72, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("/ \(target)")
                        .font(.system(size: 24))
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.vertical, 40)
                
                // Zikir Düğmesi
                Button(action: {
                    viewModel.increment()
                    
                    // Titreşim ver
                    let now = Date()
                    if now.timeIntervalSince(lastVibrationTime) >= vibrationInterval {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        lastVibrationTime = now
                    }
                    
                    // Hedefe ulaşıldığında bildirim
                    if viewModel.count == target {
                        UINotificationFeedbackGenerator().notificationOccurred(.success)
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.15))
                            .frame(width: 200, height: 200)
                            .shadow(color: .white.opacity(0.1), radius: 10)
                        
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 2)
                            .frame(width: 200, height: 200)
                        
                        Image(systemName: "hand.tap")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.white)
                    }
                }
                .padding(.bottom, 50)
                
                // Kontrol Düğmeleri
                HStack(spacing: 50) {
                    ControlButton(imageName: "text.book.closed", title: "Zikir") {
                        showDhikrPicker = true
                    }
                    
                    ControlButton(imageName: "target", title: "Hedef") {
                        showTargetPicker = true
                    }
                    
                    ControlButton(imageName: "arrow.counterclockwise", title: "Sıfırla") {
                        viewModel.reset()
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.success)
                    }
                    
                    ControlButton(imageName: "square.and.arrow.down", title: "Kaydet") {
                        viewModel.startRecording(
                            name: selectedDhikr.turkish,
                            arabic: selectedDhikr.arabic,
                            target: target
                        )
                        showSaveAlert = true
                    }
                }
                .padding(.bottom, 30)
                
                Spacer()
            }
        }
        .sheet(isPresented: $showDhikrPicker) {
            NavigationView {
                ZStack {
                    AppTheme.gradientBackground
                        .ignoresSafeArea()
                    
                    ScrollView {
                        VStack {
                            Text("Zikir Seçimi")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding(.vertical)
                            
                            LazyVStack(spacing: 16) {
                                ForEach(DhikrType.commonDhikrs) { dhikr in
                                    Button(action: {
                                        selectedDhikr = dhikr
                                        target = dhikr.recommendedCount
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
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarItems(trailing: Button("Kapat") {
                            showDhikrPicker = false
                        })
                    }
                }
                .preferredColorScheme(.dark)
            }
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
                .navigationBarItems(trailing: Button("Kapat") {
                    showTargetPicker = false
                })
            }
            .preferredColorScheme(.dark)
        }
        .sheet(isPresented: $showingRecords) {
            RecordListView(viewModel: viewModel, showingRecords: $showingRecords)
        }
        .alert(isPresented: $showSaveAlert) {
            Alert(
                title: Text("Kaydedildi"),
                message: Text("\(selectedDhikr.turkish) - \(viewModel.count) adet"),
                dismissButton: .default(Text("Tamam"))
            )
        }
        .preferredColorScheme(.dark)
    }
}
