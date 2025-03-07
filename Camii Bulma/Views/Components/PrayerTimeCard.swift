import SwiftUI

struct PrayerTimeCard: View {
    let prayerTime: PrayerTime
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
              
            }
            
            Spacer()
            
            Text(prayerTime.time)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
        }
        .padding()
        .background(AppTheme.cardBackground)
        .cornerRadius(16)
    }
}
