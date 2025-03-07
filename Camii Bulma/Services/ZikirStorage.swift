import Foundation

class ZikirStorage {
    private let key = "zikirRecords"
    
    func save(_ records: [ZikirRecord]) {
        if let encoded = try? JSONEncoder().encode(records) {
            UserDefaults.standard.set(encoded, forKey: key)
            UserDefaults.standard.synchronize() // Hemen kaydet
        }
    }
    
    func load() -> [ZikirRecord] {
        if let data = UserDefaults.standard.data(forKey: key),
           let records = try? JSONDecoder().decode([ZikirRecord].self, from: data) {
            return records
        }
        return []
    }
    
    // Test için kayıtları temizle
    func clearAll() {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
}
