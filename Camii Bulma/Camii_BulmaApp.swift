//
//  Camii_BulmaApp.swift
//  Camii Bulma
//
//  Created by Fatih Gümrükçü on 7.03.2025.
//

import SwiftUI
import UserNotifications

@main
struct Camii_BulmaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Bildirim izinlerini iste
        NotificationService.shared.requestAuthorization()
        return true
    }
    
    // APNs kayıt başarılı
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("APNs Device Token: \(token)")
    }
    
    // APNs kayıt başarısız
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs kayıt hatası: \(error)")
    }
    
    // Uzak bildirim alındı
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Uzak bildirim alındı: \(userInfo)")
        completionHandler(.newData)
    }
}
