import Foundation
import UserNotifications
import UIKit

class NotificationService: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationService()
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func requestAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound, .provisional]) { granted, error in
            if granted {
                print("APNs bildirimleri için izin alındı")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("APNs bildirimleri için izin reddedildi: \(error?.localizedDescription ?? "Bilinmeyen hata")")
            }
        }
    }
    
    func planlaNamezVaktibildirimi(vakit: String, tarih: Date, title: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = "\(vakit) vakti geldi"
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = "NAMAZ_VAKTI"
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: tarih)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: "namaz_\(vakit)_\(tarih.timeIntervalSince1970)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("APNs bildirimi planlanırken hata: \(error)")
            } else {
                print("APNs bildirimi başarıyla planlandı: \(vakit)")
            }
        }
    }
    
    // Uygulama açıkken bildirimi gösterme
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }
    
    // Bildirime tıklandığında
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let identifier = response.notification.request.identifier
        print("Bildirime tıklandı: \(identifier)")
        
        // Bildirimi sıfırla
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        
        completionHandler()
    }
}
