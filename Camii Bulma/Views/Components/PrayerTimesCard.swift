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
    
    private func getGreeting(for date: Date) -> String {
        let hour = Calendar.current.component(.hour, from: date)
        switch hour {
        case 0..<6:
            return "Hayırlı Geceler"
        case 6..<11:
            return "Hayırlı Sabahlar"
        case 11..<18:
            return "Hayırlı Günler"
        case 18..<22:
            return "Hayırlı Akşamlar"
        default:
            return "Hayırlı Geceler"
        }
    }
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.large) {
            // Current Time Section
            VStack(spacing: 12) {
                Text(getGreeting(for: currentTime))
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.bottom, 8)
                
                Text(timeFormatter.string(from: currentTime))
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.white)
                
                HStack {
                    Image(systemName: "location.circle.fill")
                    Text(viewModel.currentLocation)
                }
                .font(.system(size: 24))
                .foregroundColor(.white.opacity(0.8))
                
                Text(dateFormatter.string(from: currentTime).capitalized)
                    .font(.system(size: 20))
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(.vertical, AppTheme.Spacing.medium)
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            } else if viewModel.prayerTimes.isEmpty {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                    .padding()
            } else {
                // Prayer Times Grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: AppTheme.Spacing.small), count: 3), spacing: AppTheme.Spacing.medium) {
                    ForEach(viewModel.prayerTimes) { prayer in
                        VStack(spacing: 8) {
                            Text(prayer.name)
                                .font(.system(size: 18))
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                            
                            Text(prayer.time)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppTheme.Spacing.small)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(isNextPrayer(name: prayer.name) ? Color.white.opacity(0.2) : Color.clear)
                        )
                    }
                }
            }
        }
        .padding(AppTheme.Spacing.large)
        .frame(width: UIScreen.main.bounds.width - 2 * AppTheme.Spacing.large)
        .background(AppTheme.cardBackground)
        .cornerRadius(16)
        .onReceive(timer) { input in
            currentTime = input
        }
    }
    
    private func isNextPrayer(name: String) -> Bool {
        let now = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let currentTimeString = timeFormatter.string(from: now)
        
        if let nextPrayer = viewModel.prayerTimes
            .first(where: { timeFormatter.date(from: $0.time)! > timeFormatter.date(from: currentTimeString)! }) {
            return nextPrayer.name.lowercased() == name.lowercased()
        }
        
        return viewModel.prayerTimes.first?.name.lowercased() == name.lowercased()
    }
}
