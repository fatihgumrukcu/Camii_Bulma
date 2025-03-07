import Foundation
import CoreLocation
import MapKit

class MosqueViewModel: NSObject, ObservableObject {
    @Published var mosques: [Mosque] = []
    @Published var selectedMosque: Mosque?
    @Published var searchError: String?
    @Published var userLocation: CLLocation?
    public let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func findNearestMosques() {
        guard let userLocation = locationManager.location else {
            locationManager.requestLocation()
            return
        }
        
        // Kullanıcının etrafında 5 km yarıçapında bir arama bölgesi oluştur
        let searchRegion = MKCoordinateRegion(
            center: userLocation.coordinate,
            latitudinalMeters: 5000,
            longitudinalMeters: 5000
        )
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "cami"
        request.region = searchRegion
        
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard let self = self,
                  let response = response else {
                print("Arama hatası: \(error?.localizedDescription ?? "Bilinmeyen hata")")
                return
            }
            
            let sortedMosques = response.mapItems
                .map { item in
                    let distance = item.placemark.location?.distance(from: userLocation) ?? 0
                    return Mosque(
                        name: item.name ?? "Bilinmeyen Cami",
                        address: item.placemark.title ?? "Adres bulunamadı",
                        coordinate: item.placemark.coordinate,
                        distance: distance
                    )
                }
                .sorted { $0.distance < $1.distance }
                .prefix(10)
            
            DispatchQueue.main.async {
                self.mosques = Array(sortedMosques)
                self.userLocation = userLocation
                
                if let firstMosque = self.mosques.first {
                    self.selectedMosque = firstMosque
                }
            }
        }
    }
}

extension MosqueViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location
        print("Konum güncellendi: \(location.coordinate)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        searchError = error.localizedDescription
        print("Konum hatası: \(error.localizedDescription)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            searchError = "Konum izni reddedildi"
            print("Konum izni reddedildi")
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
}
