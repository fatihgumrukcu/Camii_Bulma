import SwiftUI
import MapKit

struct MosqueListView: View {
    @ObservedObject var viewModel: MosqueViewModel
    @State private var searchText = ""
    
    var filteredMosques: [Mosque] {
        if searchText.isEmpty {
            return viewModel.mosques
        } else {
            return viewModel.mosques.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredMosques) { mosque in
                    MosqueListItemView(mosque: mosque)
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                }
            }
            .listStyle(PlainListStyle())
            .searchable(text: $searchText, prompt: "Cami ara...")
            .navigationTitle("Camiler")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct MosqueListItemView: View {
    let mosque: Mosque
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "building.columns.fill")
                    .foregroundColor(AppTheme.primaryColor)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(mosque.name)
                        .font(AppTheme.Typography.heading)
                    
                    Text(mosque.address)
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text(mosque.formattedDistance)
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.primaryColor)
            }
            
            if let prayerTimes = mosque.prayerTimes {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Namaz Vakitleri")
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.primaryColor)
                    
                    HStack {
                        ForEach(Array(prayerTimes.formattedTimes.keys.sorted()), id: \.self) { prayer in
                            VStack {
                                Text(prayer)
                                    .font(AppTheme.Typography.caption)
                                    .foregroundColor(.gray)
                                Text(prayerTimes.formattedTimes[prayer] ?? "")
                                    .font(AppTheme.Typography.caption)
                            }
                            if prayer != prayerTimes.formattedTimes.keys.sorted().last {
                                Spacer()
                            }
                        }
                    }
                }
                .padding(.top, 8)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}
