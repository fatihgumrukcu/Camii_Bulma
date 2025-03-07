import Foundation

struct ZikirRecord: Identifiable, Codable {
    let id: UUID
    let name: String
    let arabic: String
    let count: Int
    let target: Int
    let date: Date
    
    init(id: UUID = UUID(), name: String, arabic: String, count: Int, target: Int, date: Date = Date()) {
        self.id = id
        self.name = name
        self.arabic = arabic
        self.count = count
        self.target = target
        self.date = date
    }
}
