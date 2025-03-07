import Foundation
import CoreLocation
import CoreMotion

class QiblaViewModel: NSObject, ObservableObject {
    @Published var isLoading: Bool = true
    @Published var heading: Double = 0
    @Published var qiblaAngle: Double = 0
    @Published var locationAuthStatus: String = "Konum izni gerekli"
    @Published var needsLocationPermission: Bool = true
    
    private let locationManager = LocationManager.shared
    private let compassManager = CLLocationManager()
    private var headingFilter = MovingAverageFilter(windowSize: 5)
    
    override init() {
        super.init()
        setupLocationManager()
        setupCompassManager()
        checkLocationPermission()
    }
    
    private func checkLocationPermission() {
        switch compassManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            needsLocationPermission = false
            locationAuthStatus = "Kıble yönünü bulmak için telefonu hareket ettirin"
        case .denied, .restricted:
            needsLocationPermission = true
            locationAuthStatus = "Konum izni reddedildi"
        case .notDetermined:
            needsLocationPermission = true
            locationAuthStatus = "Konum izni gerekli"
        @unknown default:
            needsLocationPermission = true
            locationAuthStatus = "Konum izni gerekli"
        }
    }
    
    func requestLocationPermission() {
        locationManager.requestLocationPermission()
        checkLocationPermission()
    }
    
    private func setupLocationManager() {
        locationManager.requestLocationPermission()
    }
    
    private func setupCompassManager() {
        compassManager.delegate = self
        compassManager.headingFilter = 1
    }
    
    func startUpdatingHeading() {
        locationManager.startUpdatingLocation()
        if CLLocationManager.headingAvailable() {
            compassManager.startUpdatingHeading()
        }
    }
    
    func stopUpdatingHeading() {
        locationManager.stopUpdatingLocation()
        compassManager.stopUpdatingHeading()
    }
    
    private func calculateQiblaDirection() {
        guard let location = locationManager.currentLocation else { return }
        
        let userLat = location.coordinate.latitude
        let userLong = location.coordinate.longitude
        
        // Kabe'nin koordinatları
        let MECCA_LATITUDE = 21.4225
        let MECCA_LONGITUDE = 39.8262
        
        // Radyanlara çevir
        let userLatRad = userLat * .pi / 180
        let userLongRad = userLong * .pi / 180
        let meccaLatRad = MECCA_LATITUDE * .pi / 180
        let meccaLongRad = MECCA_LONGITUDE * .pi / 180
        
        // Büyük daire formülü ile kıble açısını hesapla
        let deltaLong = meccaLongRad - userLongRad
        
        let y = sin(deltaLong) * cos(meccaLatRad)
        let x = cos(userLatRad) * sin(meccaLatRad) - sin(userLatRad) * cos(meccaLatRad) * cos(deltaLong)
        
        var qiblaFromNorth = atan2(y, x)
        qiblaFromNorth = qiblaFromNorth * 180 / .pi
        
        // Açıyı 0-360 arasına normalize et
        qiblaFromNorth = (qiblaFromNorth + 360).truncatingRemainder(dividingBy: 360)
        
        DispatchQueue.main.async {
            self.qiblaAngle = qiblaFromNorth
            self.isLoading = false
            self.locationAuthStatus = "Kıble yönünü bulmak için telefonu hareket ettirin"
        }
    }
}

extension QiblaViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        guard newHeading.headingAccuracy > 0 else { return }
        
        DispatchQueue.main.async {
            let smoothedHeading = self.headingFilter.add(newHeading.magneticHeading)
            self.heading = smoothedHeading
            self.calculateQiblaDirection()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationPermission()
    }
}

// Heading değerlerini yumuşatmak için Moving Average Filter
class MovingAverageFilter {
    private var values: [Double]
    private let windowSize: Int
    
    init(windowSize: Int) {
        self.windowSize = windowSize
        self.values = []
    }
    
    func add(_ value: Double) -> Double {
        values.append(value)
        if values.count > windowSize {
            values.removeFirst()
        }
        return values.reduce(0, +) / Double(values.count)
    }
}
