import SwiftUI

struct VolumeSliderView: View {
    @Binding var volumeSelected: Double
    
    var body: some View {
        VStack {
            HStack {
                Text("Drink Volume")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("\(Int(volumeSelected)) ml")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.cyan)
            }
            
            Slider(value: $volumeSelected, in: 0...1000, step: 10) {
                EmptyView()
                
            } minimumValueLabel: {
                Image(systemName: "drop")
                    .foregroundColor(.cyan.opacity(0.5))
                
            } maximumValueLabel: {
                Image(systemName: "drop.fill")
                    .foregroundColor(.cyan)
            }
            .tint(.cyan)
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(UIColor.secondarySystemGroupedBackground))
                .shadow(color: .black.opacity(0.08), radius: 5, x: 0, y: 4)
        )
    }
}

#Preview {
    VolumeSliderView(volumeSelected: .constant(100))
}
