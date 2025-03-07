import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: SettingsViewModel
    @Environment(\.openURL) var openURL
    
    var body: some View {
        ZStack {
            AppTheme.gradientBackground
                .ignoresSafeArea()
            
            List {
                Section {
                    Toggle("Namaz Vakti Bildirimleri", isOn: $viewModel.prayerNotifications)
                        .foregroundColor(.white)
                        .tint(.white)
                    Toggle("Ezan Sesi", isOn: $viewModel.adhanSound)
                        .foregroundColor(.white)
                        .tint(.white)
                } header: {
                    Text("Bildirimler")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding(.leading, -15)
                }
                .listRowBackground(AppTheme.cardBackground)
                
                Section {
                    Button(action: {
                        openURL(URL(string: "mailto:support@example.com")!)
                    }) {
                        Label("İletişime Geç", systemImage: "envelope.fill")
                            .foregroundColor(.white)
                    }
                    
                    Button(action: {
                        openURL(URL(string: "https://example.com/privacy")!)
                    }) {
                        Label("Gizlilik Politikası", systemImage: "hand.raised.fill")
                            .foregroundColor(.white)
                    }
                    
                    Button(action: {
                        openURL(URL(string: "https://example.com/terms")!)
                    }) {
                        Label("Kullanım Koşulları", systemImage: "doc.text.fill")
                            .foregroundColor(.white)
                    }
                } header: {
                    Text("Hakkında")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding(.leading, -15)
                }
                .listRowBackground(AppTheme.cardBackground)
                
                Section {
                    HStack {
                        Text("Versiyon")
                            .foregroundColor(.white)
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.white.opacity(0.7))
                    }
                } header: {
                    Text("Uygulama")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding(.leading, -15)
                }
                .listRowBackground(AppTheme.cardBackground)
            }
            .scrollContentBackground(.hidden)
            .listStyle(InsetGroupedListStyle())
            .ignoresSafeArea(edges: .bottom)
        }
        .navigationTitle("Bildirimler")
    }
}
