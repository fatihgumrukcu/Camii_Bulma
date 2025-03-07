import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    @State private var size = 0.5
    @State private var opacity = 0.0
    @State private var rotationDegrees = -30.0
    @State private var showSlogan = false
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                AppTheme.gradientBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Logo
                    Image("AppLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .shadow(color: .white.opacity(0.3), radius: 20, x: 0, y: 0)
                        .rotationEffect(.degrees(rotationDegrees))
                        .scaleEffect(size)
                        .opacity(opacity)
                    
                    // Slogan
                    VStack(spacing: 12) {
                        Text("Dua, Kıble, Zikir, Camii")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("İbadet Yolculuğun Burada!")
                            .font(.system(size: 24))
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .opacity(showSlogan ? 1 : 0)
                    .offset(y: showSlogan ? 0 : 20)
                }
                .onAppear {
                    // Logo animasyonu
                    withAnimation(.spring(response: 1.2, dampingFraction: 0.7)) {
                        self.size = 1.0
                        self.opacity = 1.0
                        self.rotationDegrees = 0
                    }
                    
                    // Slogan animasyonu
                    withAnimation(.easeOut.delay(0.8)) {
                        self.showSlogan = true
                    }
                    
                    // Ana ekrana geçiş
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        withAnimation(.easeOut(duration: 0.3)) {
                            self.isActive = true
                        }
                    }
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}
