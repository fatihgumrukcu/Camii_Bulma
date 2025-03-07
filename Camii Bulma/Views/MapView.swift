import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    @ObservedObject var viewModel: MosqueViewModel
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var selectedMosque: Mosque?
    
    var body: some View {
        ZStack {
            Map(position: $position) {
                UserAnnotation()
                
                ForEach(viewModel.mosques) { mosque in
                    Annotation(mosque.name, coordinate: mosque.coordinate) {
                        MosqueAnnotationView(mosque: mosque)
                    }
                }
            }
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
            }
            .ignoresSafeArea()
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        // Önce en yakın camileri bul
                        viewModel.findNearestMosques()
                        
                        // Kullanıcının konumuna zoom yap
                        if let userLocation = viewModel.userLocation {
                            withAnimation {
                                position = .region(MKCoordinateRegion(
                                    center: userLocation.coordinate,
                                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                                ))
                            }
                        }
                    }) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(AppTheme.cardBackground)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                    }
                    .padding(.trailing, 20)
                }
                .padding(.bottom, 40)
            }
        }
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarColorScheme(.light, for: .tabBar)
        .background(AppTheme.cardBackground)
        .onAppear {
            // Başlangıçta kullanıcının konumunu al ve oraya zoom yap
            viewModel.locationManager.startUpdatingLocation()
            
            // En yakın camileri bul
            viewModel.findNearestMosques()
            
            // Tab bar'ın rengini ayarla
            if let tabBarAppearance = UITabBar.appearance().standardAppearance.copy() as? UITabBarAppearance {
                tabBarAppearance.backgroundColor = UIColor(red: 245/255, green: 250/255, blue: 250/255, alpha: 1.0)
                UITabBar.appearance().standardAppearance = tabBarAppearance
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
        }
    }
}

struct MosqueAnnotationView: View {
    let mosque: Mosque
    @State private var showDetails = false
    
    var body: some View {
        VStack(spacing: 0) {
            Image("appiconlaunch")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .onTapGesture {
                    showDetails.toggle()
                }
            
            Image(systemName: "triangle.fill")
                .font(.system(size: 12))
                .foregroundColor(AppTheme.accentColor)
                .offset(y: -5)
        }
        .sheet(isPresented: $showDetails) {
            NavigationView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(mosque.name)
                        .font(.title)
                        .foregroundColor(.white)
                    
                    Text(mosque.address)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("Mesafe: \(mosque.formattedDistance)")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    if let prayerTimes = mosque.prayerTimes {
                        Text("Namaz Vakitleri")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.top)
                        
                        ForEach(Array(prayerTimes.formattedTimes.keys.sorted()), id: \.self) { prayer in
                            HStack {
                                Text(prayer)
                                    .foregroundColor(.white.opacity(0.8))
                                Spacer()
                                Text(prayerTimes.formattedTimes[prayer] ?? "")
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                .background(AppTheme.cardBackground.ignoresSafeArea())
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Kapat") {
                            showDetails = false
                        }
                        .foregroundColor(.white)
                    }
                }
            }
        }
    }
}
