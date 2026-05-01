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
            
            Slider(
                value: Binding(
                    get: { volumeSelected },
                    set: { newValue in
                        volumeSelected = round(newValue / 10) * 10
                    }
                ),
                in: 0...1000
            ) {
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
        .shadowSP()
    }
}

#Preview {
    @Previewable @State var volumeSelected: Double = 100.0
    VolumeSliderView(volumeSelected: $volumeSelected)
}
