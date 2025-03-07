import SwiftUI

struct PrayerTimesCard: View {
    @ObservedObject var viewModel: PrayerTimesViewModel
    @State private var currentTime = Date()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "d MMMM EEEE"
        return formatter
    }
    
    var greetingMessage: String {
        let hour = Calendar.current.component(.hour, from: currentTime)
        switch hour {
        case 5..<12:
            return "Hayırlı Sabahlar"
        case 12..<18:
            return "Hayırlı Günler"
        default:
            return "Hayırlı Akşamlar"
        }
    }
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.large) {
            // Current Time Section
            VStack(spacing: 12) {
                Text(greetingMessage)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
                
                Text(timeFormatter.string(from: currentTime))
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.white)
                
                Text(viewModel.currentLocation)
                    .font(.system(size: 24))
                    .foregroundColor(AppTheme.textColor.opacity(0.8))
                
                Text(dateFormatter.string(from: currentTime).capitalized)
                    .font(.system(size: 20))
                    .foregroundColor(AppTheme.textColor.opacity(0.7))
            }
            .padding(.vertical, AppTheme.Spacing.medium)
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            } else {
                // Prayer Times Grid
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: AppTheme.Spacing.large) {
                    ForEach(viewModel.prayerTimes) { prayerTime in
                        VStack(spacing: 12) {
                            Text(prayerTime.name)
                                .font(.system(size: 20))
                                .foregroundColor(AppTheme.textColor.opacity(0.8))
                            
                            Text(prayerTime.time)
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(AppTheme.textColor)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppTheme.Spacing.medium)
                        .padding(.horizontal, AppTheme.Spacing.small)
                        .background(AppTheme.backgroundColor)
                        .cornerRadius(12)
                    }
                }
            }
        }
        .padding(AppTheme.Spacing.large)
        .background(AppTheme.cardBackground)
        .cornerRadius(20)
        .shadow(color: AppTheme.cardShadow, radius: 8, x: 0, y: 2)
        .onReceive(timer) { input in
            currentTime = input
            // Her dakika başında namaz vakitlerini güncelle
            if Calendar.current.component(.second, from: input) == 0 {
                viewModel.fetchPrayerTimes()
            }
        }
    }
}

struct PrayerTimeItem: View {
    let name: String
    let time: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(name)
                .font(AppTheme.Typography.caption)
                .foregroundColor(.gray)
            
            Text(time)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.textColor)
        }
    }
}
