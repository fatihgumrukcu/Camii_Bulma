import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    static let shared = LocationManager()
    
    @Published var currentLocation: CLLocation?
    @Published var locationError: Error?
    @Published var placemark: CLPlacemark?
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    // Önbellek için
    private var locationCache: [String: CLPlacemark] = [:]
    private var lastGeocodeTime: Date?
    private let minimumGeocodeInterval: TimeInterval = 2.0 // 2 saniye bekleme süresi
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100 // 100 metre
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    private func geocodeLocation(_ location: CLLocation) {
        // Önbellekte varsa kullan
        let key = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
        if let cachedPlacemark = locationCache[key] {
            self.placemark = cachedPlacemark
            return
        }
        
        // Son istek zamanını kontrol et
        if let lastTime = lastGeocodeTime, 
           Date().timeIntervalSince(lastTime) < minimumGeocodeInterval {
            return
        }
        
        lastGeocodeTime = Date()
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.locationError = error
                    return
                }
                
                if let placemark = placemarks?.first {
                    // Önbelleğe kaydet
                    self?.locationCache[key] = placemark
                    self?.placemark = placemark
                }
            }
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // Konum doğruluğunu kontrol et
        guard location.horizontalAccuracy <= 100 else { return }
        
        currentLocation = location
        geocodeLocation(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationError = error
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            startUpdatingLocation()
        case .denied, .restricted:
            locationError = NSError(domain: "LocationError", 
                                  code: 1, 
                                  userInfo: [NSLocalizedDescriptionKey: "Konum izni gerekiyor"])
        default:
            break
        }
    }
}
