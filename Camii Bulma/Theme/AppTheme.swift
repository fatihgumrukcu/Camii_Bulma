import SwiftUI

struct AppTheme {
    static let primaryColor = Color(red: 64/255, green: 182/255, blue: 182/255)
    static let secondaryColor = Color(red: 52/255, green: 172/255, blue: 172/255)
    static let backgroundColor = Color(red: 32/255, green: 96/255, blue: 96/255)
    static let cardBackground = Color(red: 40/255, green: 110/255, blue: 110/255)
    static let textColor = Color.white
    static let accentColor = Color(red: 80/255, green: 200/255, blue: 200/255)
    
    struct Typography {
        static let title = Font.system(size: 24, weight: .bold)
        static let heading = Font.system(size: 20, weight: .semibold)
        static let body = Font.system(size: 16, weight: .regular)
        static let caption = Font.system(size: 14, weight: .regular)
        static let largeTitle = Font.system(size: 36, weight: .bold)
    }
    
    struct Spacing {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
    }
    
    static let gradientBackground = LinearGradient(
        colors: [
            Color(red: 32/255, green: 96/255, blue: 96/255),
            Color(red: 28/255, green: 85/255, blue: 85/255)
        ],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let cardShadow = Color.black.opacity(0.25)
}
