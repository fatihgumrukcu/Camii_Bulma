import SwiftUI

struct DailyVerseCard: View {
    let verse: DailyVerse
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Text(verse.arabicText)
                .font(.system(size: 24))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text(verse.turkishMeaning)
                .font(.system(size: 18))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
            
            Text(verse.source)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .frame(width: UIScreen.main.bounds.width - 2 * AppTheme.Spacing.large, height: 200)
        .padding()
        .background(AppTheme.cardBackground)
        .cornerRadius(16)
    }
}
