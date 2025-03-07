import Foundation
import CoreLocation
import MapKit

struct Mosque: Identifiable {
    let id = UUID()
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    let distance: CLLocationDistance
    let prayerTimes: PrayerTimes?
    
    init(name: String, address: String, coordinate: CLLocationCoordinate2D, distance: CLLocationDistance = 0, prayerTimes: PrayerTimes? = nil) {
        self.name = name
        self.address = address
        self.coordinate = coordinate
        self.distance = distance
        self.prayerTimes = prayerTimes
    }
    
    var formattedDistance: String {
        if distance < 1000 {
            return String(format: "%.0f m", distance)
        } else {
            return String(format: "%.1f km", distance / 1000)
        }
    }
}

struct PrayerTimes: Codable {
    let fajr: Date      // İmsak
    let sunrise: Date   // Güneş
    let dhuhr: Date     // Öğle
    let asr: Date       // İkindi
    let maghrib: Date   // Akşam
    let isha: Date      // Yatsı
    
    var formattedTimes: [String: String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        return [
            "İmsak": formatter.string(from: fajr),
            "Güneş": formatter.string(from: sunrise),
            "Öğle": formatter.string(from: dhuhr),
            "İkindi": formatter.string(from: asr),
            "Akşam": formatter.string(from: maghrib),
            "Yatsı": formatter.string(from: isha)
        ]
    }
}
