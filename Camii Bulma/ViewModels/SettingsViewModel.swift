import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var prayerNotifications: Bool = true {
        didSet {
            saveSettings()
            if prayerNotifications {
                NotificationService.shared.requestAuthorization()
            } else {
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            }
        }
    }
    
    init() {
        loadSettings()
        checkNotificationStatus()
    }
    
    private func loadSettings() {
        let defaults = UserDefaults.standard
        prayerNotifications = defaults.bool(forKey: "prayerNotifications")
    }
    
    private func saveSettings() {
        let defaults = UserDefaults.standard
        defaults.set(prayerNotifications, forKey: "prayerNotifications")
    }
    
    private func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.prayerNotifications = settings.authorizationStatus == .authorized
            }
        }
    }
}
