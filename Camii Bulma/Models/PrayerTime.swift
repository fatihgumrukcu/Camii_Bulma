import Foundation

struct PrayerTimeResponse: Codable {
    let success: Bool
    let result: [PrayerTimeResult]
}

struct PrayerTimeResult: Codable {
    let saat: String
    let vakit: String
}

struct PrayerTime: Identifiable {
    let id = UUID()
    let name: String
    let time: String
    
    static let sampleTimes = [
        PrayerTime(name: "İmsak", time: "05:30"),
        PrayerTime(name: "Güneş", time: "07:15"),
        PrayerTime(name: "Öğle", time: "13:00"),
        PrayerTime(name: "İkindi", time: "16:15"),
        PrayerTime(name: "Akşam", time: "19:30"),
        PrayerTime(name: "Yatsı", time: "21:00")
    ]
}
