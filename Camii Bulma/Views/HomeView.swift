import SwiftUI

struct HomeView: View {
    @StateObject private var prayerTimesViewModel = PrayerTimesViewModel()
    @State private var selectedPrayer: Prayer?
    @State private var showingPrayerDetail = false
    
    var body: some View {
        ZStack {
            AppTheme.gradientBackground
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    // Prayer Times Section
                    VStack(spacing: 16) {
                        Text("Namaz Vakitleri")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        
                        PrayerTimesCard(viewModel: prayerTimesViewModel)
                            .padding(.horizontal, 8)
                    }
                    .onAppear {
                        // View görünür olduğunda namaz vakitlerini güncelle
                        prayerTimesViewModel.fetchPrayerTimes()
                    }
                    
                    // Prayer Duas Section
                    VStack(spacing: 16) {
                        Text("Namaz Duaları")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                        
                        TabView {
                            ForEach(PrayerData.prayers) { prayer in
                                PrayerCard(prayer: prayer)
                                    .onTapGesture {
                                        selectedPrayer = prayer
                                        showingPrayerDetail = true
                                    }
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                        .frame(height: 250)
                    }
                    .padding(.horizontal)
                    
                    // Daily Verse Section
                    VStack(spacing: 16) {
                        Text("Günün Ayeti")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                        
                        TabView {
                            ForEach(PrayerData.dailyVerses) { verse in
                                DailyVerseCard(verse: verse)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                        .frame(height: 250)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .sheet(isPresented: $showingPrayerDetail) {
            if let prayer = selectedPrayer {
                PrayerDetailView(prayer: prayer)
            }
        }
    }
}
