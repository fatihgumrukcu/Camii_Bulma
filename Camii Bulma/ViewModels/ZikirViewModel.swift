import Foundation
import SwiftUI

class ZikirViewModel: ObservableObject {
    @Published var records: [ZikirRecord] = []
    @Published var count: Int = 0
    @Published var statistics: Statistics = Statistics()
    private let storage = ZikirStorage()
    
    struct Statistics {
        var totalCount: Int = 0
        var dailyCount: Int = 0
        var weeklyCount: Int = 0
        var monthlyCount: Int = 0
    }
    
    init() {
        loadRecords()
        calculateStatistics()
    }
    
    func increment() {
        count += 1
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    func reset() {
        count = 0
    }
    
    func startRecording(name: String, arabic: String, target: Int) {
        print("Kayıt başlıyor: \(name), \(count)/\(target)")
        let record = ZikirRecord(name: name, arabic: arabic, count: count, target: target)
        records.append(record)
        saveRecords()
        print("Kayıt tamamlandı. Toplam kayıt: \(records.count)")
    }
    
    private func loadRecords() {
        records = storage.load()
        print("Kayıtlar yüklendi: \(records.count)")
    }
    
    private func calculateStatistics() {
        let calendar = Calendar.current
        let now = Date()
        
        var stats = Statistics()
        
        for record in records {
            stats.totalCount += record.count
            
            if calendar.isDateInToday(record.date) {
                stats.dailyCount += record.count
            }
            
            if calendar.isDate(record.date, equalTo: now, toGranularity: .weekOfYear) {
                stats.weeklyCount += record.count
            }
            
            if calendar.isDate(record.date, equalTo: now, toGranularity: .month) {
                stats.monthlyCount += record.count
            }
        }
        
        statistics = stats
        print("İstatistikler güncellendi: \(stats.totalCount) toplam")
    }
    
    func saveRecords() {
        storage.save(records)
        calculateStatistics()
    }
}
