import Foundation

struct Prayer: Identifiable {
    let id = UUID()
    let name: String
    let arabicText: String
    let turkishPronunciation: String
    let meaning: String
}

struct DailyVerse: Identifiable {
    let id = UUID()
    let arabicText: String
    let turkishMeaning: String
    let source: String
}
