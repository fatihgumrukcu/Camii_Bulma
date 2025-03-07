import SwiftUI

struct PrayerCard: View {
    let prayer: Prayer
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Text(prayer.name)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .frame(height: 30) // Başlık için sabit yükseklik
            
            Text(prayer.arabicText)
                .font(.system(size: 20))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .frame(height: 100) // Arapça metin için sabit yükseklik
            
            Text(prayer.turkishPronunciation)
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .frame(height: 70) // Türkçe okunuş için sabit yükseklik
        }
        .frame(width: UIScreen.main.bounds.width - 2 * AppTheme.Spacing.large, height: 250)
        .padding()
        .background(AppTheme.cardBackground)
        .cornerRadius(16)
    }
}
