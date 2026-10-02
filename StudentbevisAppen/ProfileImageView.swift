import SwiftUI

struct ProfileImageView: View {
    let imageData: Data?
    let scale: Double
    let offsetX: Double
    let offsetY: Double
    let size: CGFloat
    var showsBackground = true

    var body: some View {
        ZStack {
            if showsBackground {
                Circle()
                    .fill(Color.white.opacity(0.95))
            }

            if let imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .scaleEffect(scale)
                    .offset(x: offsetX, y: offsetY)
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color.gray.opacity(0.75))
                    .padding(size * 0.08)
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
    }
}
