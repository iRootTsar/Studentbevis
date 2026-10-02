import SwiftUI

struct EuropeanStudentCardButton: View {
    let boxWidth: CGFloat
    var layoutScale: CGFloat = 1
    let isPressed: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 18 * layoutScale) {
                Text("European Student Card")
                    .font(.system(size: 22 * layoutScale, weight: .light))
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)

                Image(systemName: "qrcode")
                    .font(.system(size: 22 * layoutScale))
            }
            .foregroundColor(Color.primary)
            .padding(.horizontal, 18 * layoutScale)
            .frame(width: boxWidth, height: 70 * layoutScale)
            .background(Color("Backgroundscreen"))
            .overlay(
                RoundedRectangle(cornerRadius: 30 * layoutScale)
                    .stroke(Color("Verify"), lineWidth: 3.5)
            )
            .clipShape(RoundedRectangle(cornerRadius: 30 * layoutScale))
            .opacity(isPressed ? 0.55 : 1)
            .scaleEffect(isPressed ? 0.985 : 1)
        }
        .buttonStyle(.plain)
    }
}

struct EuropeanStudentCardOverlay: View {
    let width: CGFloat
    var layoutScale: CGFloat = 1
    let isSlidingDown: Bool
    let closeAction: () -> Void

    @State private var closeButtonPressed = false

    private let linkURL = URL(string: "https://erasmus-plus.ec.europa.eu/european-student-card-initiative")!

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer(minLength: topSpacer)

                cardContent()
                    .frame(width: width)
                    .scaleEffect(popupScale, anchor: .top)
                    .offset(y: isSlidingDown ? geometry.size.height + geometry.size.height : restingOffset)
                    .transition(.move(edge: .bottom))

                Spacer(minLength: 24)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private var popupScale: CGFloat {
        min(1, max(0.94, layoutScale + 0.04))
    }

    private var topSpacer: CGFloat {
        124 + (1 - layoutScale) * 140
    }

    private var restingOffset: CGFloat {
        -28 * layoutScale + (layoutScale < 1 ? 5 : 0)
    }

    private func cardContent() -> some View {
        let logoWidth = width * 0.54
        let qrWidth = width * 0.67

        return VStack(spacing: 6) {
            Text("European Student\nCard")
                .font(.system(size: 29, weight: .light))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.7)

            EuropeanStudentCardLogo(width: logoWidth)
                .frame(width: logoWidth, height: 52)
                .padding(.top, 10)

            Image("QRcode")
                .resizable()
                .interpolation(.none)
                .scaledToFit()
                .frame(width: qrWidth, height: qrWidth)
                .accessibilityLabel("European Student Card QR code")
                .padding(.top, -16)

            Text("This QR Code can be read to validate\nstudent status for services across Europe.")
                .font(.system(size: 14))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.78)
                .padding(.horizontal, 14)
                .padding(.vertical, 15)
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.80, green: 0.88, blue: 1.0))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.horizontal, 28)
                .padding(.top, 8)

            Button {
                UIApplication.shared.open(linkURL)
            } label: {
                Text("Read more about the European Student Card")
                    .font(.system(size: 15))
                    .foregroundColor(Color(red: 0.0, green: 0.16, blue: 0.55))
                    .underline()
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 5)
            .padding(.horizontal, 28)

            Button(action: closeButtonTapped) {
                Text("Close")
                    .font(.system(size: 25, weight: .light))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 62)
                    .background(Color("Verify"))
                    .clipShape(RoundedRectangle(cornerRadius: 21))
                    .opacity(closeButtonPressed ? 0.65 : 1)
                    .scaleEffect(closeButtonPressed ? 0.985 : 1)
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 28)
            .padding(.top, 12)
        }
        .padding(.top, 15)
        .padding(.bottom, 15)
        .background(Color("Backgroundscreen"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color("Verify"), lineWidth: 3)
        )
    }

    private func closeButtonTapped() {
        withAnimation(.easeInOut(duration: 0.08)) {
            closeButtonPressed = true
        }

        withAnimation(.easeInOut(duration: 0.08).delay(0.08)) {
            closeButtonPressed = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            closeAction()
        }
    }
}

private struct EuropeanStudentCardLogo: View {
    let width: CGFloat

    var body: some View {
        let flagWidth = width * 0.34
        let spacing: CGFloat = 16
        let textWidth = width - flagWidth - spacing

        return HStack(spacing: spacing) {
            EuropeanUnionFlag()
                .frame(width: flagWidth, height: flagWidth * 0.66)

            Text("European\nStudent Card")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color(red: 0.0, green: 0.24, blue: 0.64))
                .lineLimit(2)
                .minimumScaleFactor(0.8)
                .frame(width: textWidth, alignment: .leading)
        }
        .frame(width: width, alignment: .leading)
    }
}

private struct EuropeanUnionFlag: View {
    private let starPositions: [(x: CGFloat, y: CGFloat)] = [
        (0.50, 0.20), (0.65, 0.24), (0.76, 0.35), (0.80, 0.50),
        (0.76, 0.65), (0.65, 0.76), (0.50, 0.80), (0.35, 0.76),
        (0.24, 0.65), (0.20, 0.50), (0.24, 0.35), (0.35, 0.24)
    ]

    var body: some View {
        GeometryReader { geometry in
            let side = min(geometry.size.width, geometry.size.height)
            let centerX = geometry.size.width / 2
            let centerY = geometry.size.height / 2
            let radius = side * 0.30

            ZStack {
                Rectangle()
                    .fill(Color(red: 0.0, green: 0.20, blue: 0.62))

                ForEach(starPositions.indices, id: \.self) { index in
                    Image(systemName: "star.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: geometry.size.width * 0.055)
                        .position(
                            x: centerX + (starPositions[index].x - 0.5) * radius * 2,
                            y: centerY + (starPositions[index].y - 0.5) * radius * 2
                        )
                }
            }
        }
    }
}
