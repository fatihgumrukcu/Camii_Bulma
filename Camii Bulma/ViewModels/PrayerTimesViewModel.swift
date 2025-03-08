import SwiftUI
import CoreLocation

class PrayerTimesViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var prayerTimes: [PrayerTime] = []
    @Published var errorMessage: String?
    @Published var currentLocation: String = "İstanbul"
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    private let apiKey = "0QhLhFqt57HIhaQXnbMkg:4Bhtr27LLxG0BAIC8QNGSq"
    private let baseURL = "https://api.collectapi.com/pray/all"
    private let settingsViewModel = SettingsViewModel()
    
    override init() {
        super.init()
        setupLocationManager()
        print("⏰ PrayerTimesViewModel: Başlatılıyor...")
        fetchPrayerTimes()
    }
    
    // Test bildirimi gönderme fonksiyonu
    func sendTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Test Bildirimi"
        content.body = "Namaz vakti bildirimleri başarıyla ayarlandı"
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        // 5 saniye sonra bildirim gönder
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "test_notification",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Test bildirimi gönderilirken hata: \(error)")
            } else {
                print("Test bildirimi başarıyla gönderildi")
            }
        }
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func planlaNamezVaktiBildirimleri() {
        guard settingsViewModel.prayerNotifications else { return }
        
        // Önce mevcut bildirimleri temizle
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        for prayerTime in prayerTimes {
            if let date = dateFormatter.date(from: prayerTime.time) {
                let vakit = prayerTime.name.capitalized
                NotificationService.shared.planlaNamezVaktibildirimi(
                    vakit: vakit,
                    tarih: date,
                    title: "Namaz Vakti"
                )
                print("🔔 \(vakit) için bildirim planlandı: \(prayerTime.time)")
            }
        }
    }
    
    func fetchPrayerTimes() {
        print("⏰ PrayerTimesViewModel: Namaz vakitleri yükleniyor...")
        
        let headers = [
            "content-type": "application/json",
            "authorization": "apikey \(apiKey)"
        ]
        
        guard var urlComponents = URLComponents(string: baseURL) else {
            self.errorMessage = "Geçersiz URL"
            print("❌ PrayerTimesViewModel: Geçersiz URL")
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "data.city", value: "istanbul")
        ]
        
        guard let url = urlComponents.url else {
            self.errorMessage = "Geçersiz URL"
            print("❌ PrayerTimesViewModel: URL oluşturulamadı")
            return
        }
        
        print("🌐 PrayerTimesViewModel: İstek URL'i: \(url.absoluteString)")
        
        var request = URLRequest(url: url,
                               cachePolicy: .returnCacheDataElseLoad,
                               timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    print("❌ PrayerTimesViewModel: Hata: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "Veri alınamadı"
                    print("❌ PrayerTimesViewModel: Veri alınamadı")
                    return
                }
                
                print("📦 PrayerTimesViewModel: Veri alındı, boyut: \(data.count) bytes")
                
                do {
                    let response = try JSONDecoder().decode(PrayerTimeResponse.self, from: data)
                    if response.success {
                        let times = response.result.map { result in
                            PrayerTime(name: result.vakit,
                                     time: result.saat)
                        }
                        self?.prayerTimes = times
                        print("✅ PrayerTimesViewModel: Başarılı! \(times.count) namaz vakti yüklendi")
                        print("📋 Namaz Vakitleri:")
                        times.forEach { time in
                            print("   • \(time.name): \(time.time)")
                        }
                        self?.planlaNamezVaktiBildirimleri() // Bildirimleri planla
                    } else {
                        self?.errorMessage = "API yanıtı başarısız"
                        print("❌ PrayerTimesViewModel: API yanıtı başarısız")
                    }
                } catch {
                    self?.errorMessage = "Veri işlenirken hata oluştu: \(error.localizedDescription)"
                    print("❌ PrayerTimesViewModel: JSON çözümleme hatası: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first {
                DispatchQueue.main.async {
                    if let district = placemark.subLocality {
                        self?.currentLocation = district
                    } else if let city = placemark.locality {
                        self?.currentLocation = city
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
}
