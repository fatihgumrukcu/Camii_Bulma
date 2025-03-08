import SwiftUI
import CoreLocation

#if canImport(UIKit)
import UIKit
#endif

struct QiblaView: View {
    @StateObject private var viewModel = QiblaViewModel()
    @State private var glowScale: CGFloat = 1.0
    @State private var showAnimation = false
    @State private var lastVibrationTime = Date()
    private let vibrationInterval: TimeInterval = 1.0 // 1 saniye aralıkla titreşim
    @Environment(\.scenePhase) private var scenePhase

    private var compassCircle: some View {
        ZStack {
            // Dış daire
            Circle()
                .stroke(.white, lineWidth: 3)
                .frame(width: 320, height: 320)
            
            // İç daire
            Circle()
                .fill(.white.opacity(0.1))
                .frame(width: 280, height: 280)
            
            // Yön çizgileri
            ForEach(0..<12) { i in
                let degree = Double(i * 30)
                Rectangle()
                    .fill(.white.opacity(i % 3 == 0 ? 1 : 0.5))
                    .frame(width: i % 3 == 0 ? 2 : 1, height: i % 3 == 0 ? 20 : 10)
                    .offset(y: -140)
                    .rotationEffect(.degrees(degree))
            }
            
            // Dış yön yazıları
            ForEach(["K", "G", "D", "B"], id: \.self) { direction in
                Text(direction)
                    .foregroundColor(.white)
                    .font(.system(size: 24, weight: .bold))
                    .position(
                        x: 160 + 175 * (direction == "D" ? 1 : direction == "B" ? -1 : 0),
                        y: 160 + 175 * (direction == "K" ? -1 : direction == "G" ? 1 : 0)
                    )
            }
            
            // Kıble göstergesi
            QiblaPointer(heading: viewModel.heading, qiblaAngle: viewModel.qiblaAngle, glowScale: $glowScale, isCloseToQibla: isCloseToQibla())
        }
    }
    
    var body: some View {
        ZStack {
            AppTheme.gradientBackground
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("Kıble Yönü")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 50)
                
                Spacer()
                
                compassCircle
                    .frame(width: 320, height: 320)
                
                // Kıble durumu
                StatusCard(
                    heading: viewModel.heading,
                    qiblaAngle: viewModel.qiblaAngle,
                    showAnimation: showAnimation,
                    isCloseToQibla: isCloseToQibla()
                )
                
                // Konum izni butonu
                if viewModel.needsLocationPermission {
                    LocationPermissionButton {
                        viewModel.requestLocationPermission()
                    }
                }
                
                Spacer()
            }
        }
        .onAppear {
            viewModel.startUpdatingHeading()
            withAnimation(.easeInOut(duration: 1).repeatForever()) {
                showAnimation.toggle()
            }
        }
        .onDisappear {
            viewModel.stopUpdatingHeading()
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .active:
                viewModel.startUpdatingHeading()
                withAnimation(.easeInOut(duration: 1).repeatForever()) {
                    showAnimation.toggle()
                }
            case .inactive, .background:
                viewModel.stopUpdatingHeading()
            @unknown default:
                break
            }
        }
        .onChange(of: viewModel.heading) { heading in
            checkQiblaAlignment(direction: heading)
        }
    }
    
    private func isCloseToQibla() -> Bool {
        let difference = abs(viewModel.heading - viewModel.qiblaAngle)
        return difference < 5 || difference > 355
    }
    
    private func checkQiblaAlignment(direction: Double) {
        if isCloseToQibla() {
            withAnimation(.easeInOut(duration: 0.3)) {
                glowScale = 1.5
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeInOut(duration: 0.5).repeatForever()) {
                    glowScale = 1.2
                }
            }
        }
        
        // Kıble yönü ile cihaz yönü arasındaki fark 5 dereceden az ise
        if abs(direction - viewModel.qiblaAngle) < 5.0 {
            let now = Date()
            // Son titreşimden beri yeterli süre geçtiyse
            if now.timeIntervalSince(lastVibrationTime) >= vibrationInterval {
                #if os(iOS)
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.prepare()
                generator.impactOccurred()
                #endif
                lastVibrationTime = now
            }
        }
    }
}

struct QiblaPointer: View {
    let heading: Double
    let qiblaAngle: Double
    @Binding var glowScale: CGFloat
    let isCloseToQibla: Bool
    
    var body: some View {
        ZStack {
            // Kıble oku
            Circle()
                .fill(.white)
                .frame(width: 140, height: 140)
            
            VStack(spacing: -5) {
                Image(systemName: "location.north.fill")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .foregroundColor(AppTheme.cardBackground)
                
                Text("Kıble")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(AppTheme.cardBackground)
            }
            .rotationEffect(.degrees(-heading))
            .animation(.interpolatingSpring(mass: 1.0, stiffness: 100, damping: 15), value: heading)
            .overlay {
                if isCloseToQibla {
                    VStack(spacing: -5) {
                        Image(systemName: "location.north.fill")
                            .resizable()
                            .frame(width: 70, height: 70)
                            .foregroundColor(AppTheme.accentColor)
                        
                        Text("Kıble")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(AppTheme.accentColor)
                    }
                    .rotationEffect(.degrees(-heading))
                    .scaleEffect(glowScale)
                    .opacity(0.5)
                    .blur(radius: 20)
                }
            }
        }
        .rotationEffect(.degrees(qiblaAngle))
    }
}

struct StatusCard: View {
    let heading: Double
    let qiblaAngle: Double
    let showAnimation: Bool
    let isCloseToQibla: Bool
    
    var body: some View {
        VStack(spacing: 15) {
            if isCloseToQibla {
                Text("Kıble Yönündesiniz")
                    .font(.headline)
                    .foregroundColor(.white)
                    .opacity(showAnimation ? 1 : 0.7)
                    .scaleEffect(showAnimation ? 1.1 : 1.0)
            } else {
                let difference = (heading - qiblaAngle).truncatingRemainder(dividingBy: 360)
                Text("\(Int(abs(difference < 180 ? difference : 360 - difference)))° \(difference < 180 ? "Sola" : "Sağa") Dönün")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "location.north")
                    Text("Pusula: \(Int(heading))°")
                }
                .font(.system(size: 20))
                .foregroundColor(.white)
                
                HStack {
                    Image(systemName: "star.fill")
                    Text("Kıble: \(Int(qiblaAngle))°")
                }
                .font(.system(size: 20))
                .foregroundColor(.white)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppTheme.cardBackground.opacity(0.3))
        )
        .padding(.horizontal)
    }
}

struct LocationPermissionButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "location.fill")
                Text("Konum İzni Ver")
            }
            .foregroundColor(.white)
            .padding()
            .background(AppTheme.cardBackground)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.2), radius: 5)
        }
    }
}
