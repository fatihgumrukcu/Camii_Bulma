import SwiftUI

struct PrayerDetailView: View {
    let prayer: Prayer
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .center, spacing: 32) {
                Text(prayer.name)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 24)
                
                VStack(spacing: 4) {
                    Text("Sure")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                    Text(prayer.arabicText)
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
                
                VStack(spacing: 4) {
                    Text("Okunuşu")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                    Text(prayer.turkishPronunciation)
                        .font(.system(size: 20))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                
                VStack(spacing: 4) {
                    Text("Türkçe Meali")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                    Text(prayer.meaning)
                        .font(.system(size: 18))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 32)
        }
        .background(AppTheme.cardBackground.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white)
                }
            }
        }
    }
}
