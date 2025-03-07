import SwiftUI

struct ContentView: View {
    @StateObject private var prayerTimesViewModel = PrayerTimesViewModel()
    @StateObject private var mosqueViewModel = MosqueViewModel()
    @StateObject private var settingsViewModel = SettingsViewModel()
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        tabBarAppearance.backgroundColor = UIColor(red: 242/255, green: 247/255, blue: 247/255, alpha: 1.0)
        
        tabBarAppearance.shadowColor = nil
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().unselectedItemTintColor = UIColor(red: 40/255, green: 110/255, blue: 110/255, alpha: 1.0)
        UITabBar.appearance().isTranslucent = false
    }
    
    var body: some View {
        TabView {
            HomeView()
                .environmentObject(prayerTimesViewModel)
                .tabItem {
                    Label("Ana Sayfa", systemImage: "house.fill")
                }
            
            MapView(viewModel: mosqueViewModel)
                .tabItem {
                    Label("Harita", systemImage: "map.fill")
                }
            
            QiblaView()
                .tabItem {
                    Label("Kıble", systemImage: "location.north.fill")
                }
            
            ZikirmatikView()
                .tabItem {
                    Label("Zikirmatik", systemImage: "rosette")
                }
            
            SettingsView()
                .environmentObject(settingsViewModel)
                .tabItem {
                    Label("Ayarlar", systemImage: "gear")
                }
        }
        .tint(AppTheme.cardBackground)
    }
}

#Preview {
    ContentView()
}
