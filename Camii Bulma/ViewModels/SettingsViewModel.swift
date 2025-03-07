import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var prayerNotifications: Bool = true
    @Published var adhanSound: Bool = true
    
    init() {
        // Load saved settings
        loadSettings()
    }
    
    private func loadSettings() {
        // Load settings from UserDefaults
        let defaults = UserDefaults.standard
        prayerNotifications = defaults.bool(forKey: "prayerNotifications")
        adhanSound = defaults.bool(forKey: "adhanSound")
    }
    
    func saveSettings() {
        // Save settings to UserDefaults
        let defaults = UserDefaults.standard
        defaults.set(prayerNotifications, forKey: "prayerNotifications")
        defaults.set(adhanSound, forKey: "adhanSound")
    }
}
