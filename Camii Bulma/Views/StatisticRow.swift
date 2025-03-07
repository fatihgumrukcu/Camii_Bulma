import SwiftUI

struct StatisticRow: View {
    let title: String
    let count: Int
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            
            Spacer()
            
            Text("\(count)")
                .font(.title3)
                .bold()
                .foregroundColor(.white)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}
