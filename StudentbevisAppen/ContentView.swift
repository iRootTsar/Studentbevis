//
//  ContentView.swift
//  StudentbevisAppen
//
//  Created by Vladimirs Civilgins on 04/08/2024.
//
import SwiftUI

struct ContentView: View {
    @ObservedObject var profileStore: StudentProfileStore
    @State private var showPopup = false
    @State private var slideDown = false
    @State private var showSettingsMenu = false
    @State private var showTerms = false
    @State private var showLibraryCard = false
    @State private var showProfileEditor = false
    @State private var showEuropeanStudentCard = false
    @State private var europeanStudentCardSlideDown = false
    @State private var europeanStudentCardButtonPressed = false
    @State private var isVerifying = false
    @State private var validIDColor = Color("ValidID")
    @State private var validIDTextColor = Color.primary
    @State private var verifyButtonColor = Color("Verify")
    @State private var isBlinking = false

    // Parameters for positioning and sizing
    let settingsButtonPaddingTop: CGFloat = 50
    let settingsButtonPaddingTrailing: CGFloat = 53
    let overlayPaddingBelowHeader: CGFloat = 110

    var body: some View {
        GeometryReader { geometry in
            let layout = MainScreenLayout(size: geometry.size)

            ZStack {
                Color("Backgroundscreen")
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    HStack {
                        Image("SiktLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 60) // Adjust the width and height accordingly
                            .padding(.top, settingsButtonPaddingTop)
                            .padding(.leading, 30)
                            .onTapGesture(count: 3) {
                                showProfileEditor = true
                            }
                        Spacer()
                        DropdownButton(showSettingsMenu: $showSettingsMenu)
                            .padding(.trailing, settingsButtonPaddingTrailing)
                            .padding(.top, settingsButtonPaddingTop)
                    }
                    .frame(height: 110)
                    .background(Color("NavAndInfoColor"))
                    .edgesIgnoringSafeArea(.top)
                    .overlay(
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(Color("Verify")),
                        alignment: .bottom
                    )

                    ZStack {
                        ProfileImageView(
                            imageData: profile?.profileImageData,
                            scale: profile?.profileImageScale ?? 1,
                            offsetX: profile?.profileImageOffsetX ?? 0,
                            offsetY: profile?.profileImageOffsetY ?? 0,
                            size: layout.profileImageSize
                        )
                            .padding(.top, layout.profileImageVerticalPadding)
                            .padding(.bottom, layout.profileImageVerticalPadding)

                        Circle()
                            .fill(Color.white.opacity(isBlinking ? 0.3 : 0))
                            .frame(width: layout.profileImageSize, height: layout.profileImageSize)
                    }
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.1)) {
                            isBlinking = true
                        }
                        withAnimation(.easeInOut(duration: 0.1).delay(0.1)) {
                            isBlinking = false
                        }
                        withAnimation(.easeInOut(duration: 0.3).delay(0.2)) {
                            showPopup = true
                            slideDown = false
                            changeStatusBarAppearance(darkMode: true)
                        }
                    }

                    VStack {
                        if let profile {
                            InfoBoxView(
                                boxWidth: layout.boxWidth,
                                layoutScale: layout.scale,
                                profile: profile
                            )
                            .padding(.horizontal)

                            ValidIDView(
                                boxWidth: layout.boxWidth,
                                layoutScale: layout.scale,
                                verticalSpacing: layout.sectionSpacing,
                                profile: profile,
                                validIDColor: $validIDColor,
                                validIDTextColor: $validIDTextColor,
                                isVerifying: $isVerifying,
                                verifyButtonColor: $verifyButtonColor,
                                verifyAction: verifyButtonTapped
                            )
                            .padding(.horizontal)
                        }

                        EuropeanStudentCardButton(
                            boxWidth: layout.boxWidth,
                            layoutScale: layout.scale,
                            isPressed: europeanStudentCardButtonPressed,
                            action: europeanStudentCardButtonTapped
                        )
                        .padding(.horizontal)
                        .padding(.top, layout.europeanButtonTopPadding)

                        VStack(spacing: layout.footerSpacing) {
                            (
                                Text("Last updated: ")
                                    .bold()
                                + Text("\(Date(), formatter: dateFormatter) at \(Date(), formatter: timeFormatter) (\(timeZoneAbbreviation))")
                            )
                                .font(.system(size: layout.footerFontSize))
                            (
                                Text("Timezone: ")
                                    .bold()
                                + Text(TimeZone.current.identifier)
                            )
                                .font(.system(size: layout.footerFontSize))
                            Text("Version: \(profile?.version ?? "Not configured")")
                                .bold()
                                .font(.system(size: layout.footerFontSize))
                        }
                        .padding(.top, layout.footerTopPadding)
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.primary)

                        Spacer()
                    }
                    .environment(\.colorScheme, .light)
                }

                if showSettingsMenu {
                    Color.white.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showSettingsMenu = false
                            }
                        }

                    DropdownMenu(showTerms: $showTerms, showLibraryCard: $showLibraryCard)
                        .padding(.trailing, settingsButtonPaddingTrailing - 10)
                        .padding(.top, settingsButtonPaddingTop + 53)
                        .transition(.opacity)
                }
                if showLibraryCard {
                    Color.white.opacity(0.7)
                    .edgesIgnoringSafeArea([.horizontal, .bottom])
                    .padding(.top, 153)
                    .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showLibraryCard = false
                        showSettingsMenu = false
                        }
                    }
                }

                if showPopup {
                    Color.black.opacity(0.6)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            closeProfilePopup()
                        }

                    VStack {
                        Spacer()
                        ZStack {
                            ProfilePopupImageView(profile: profile)
                                .frame(width: 310, height: 340)
                                .background(Color.white)
                                .clipShape(Rectangle())
                                .shadow(radius: 10)
                                .overlay(
                                    VStack {
                                        HStack {
                                            Spacer()
                                            Image("CancelButton")
                                                .resizable()
                                                .frame(width: 30, height: 30)
                                                .offset(x: 0, y: -40)
                                                .onTapGesture {
                                                    closeProfilePopup()
                                                }
                                        }
                                        Spacer()
                                    }
                                )
                                .transition(.move(edge: .bottom))
                        }
                        .offset(y: slideDown ? geometry.size.height + 420 : 0)
                        Spacer(minLength: 300)
                    }
                    .transition(.move(edge: .bottom))
                }

                if showEuropeanStudentCard {
                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: overlayPaddingBelowHeader)

                        Color.white.opacity(0.22)
                            .ignoresSafeArea(edges: [.horizontal, .bottom])
                    }
                    .ignoresSafeArea(edges: [.horizontal, .bottom])
                        .onTapGesture {
                            closeEuropeanStudentCard()
                        }

                    EuropeanStudentCardOverlay(
                        width: layout.europeanStudentCardOverlayWidth,
                        layoutScale: layout.scale,
                        isSlidingDown: europeanStudentCardSlideDown,
                        closeAction: closeEuropeanStudentCard
                    )
                }

                if showTerms {
                    TermsView(showTerms: $showTerms, showSettingsMenu: $showSettingsMenu)
                        .transition(.opacity)
                }
                if showLibraryCard {
                    LibraryCardView(
                        profile: profile,
                        showLibraryCard: $showLibraryCard,
                        showSettingsMenu: $showSettingsMenu
                    )
                        .transition(.opacity)
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
        .onChange(of: showTerms) { oldValue, newValue in
            if newValue {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showSettingsMenu = false
                }
            }
        }
        .onChange(of: showLibraryCard) { oldValue, newValue in
            if newValue {
                showSettingsMenu = false
            }
        }
        .sheet(isPresented: $showProfileEditor) {
            StudentProfileEditorView(
                profile: profile,
                isFirstTimeSetup: false
            ) { profile in
                profileStore.save(profile)
            }
        }
    }

    private var profile: StudentProfile? {
        profileStore.profile
    }

    private func closeProfilePopup() {
        withAnimation(.easeInOut(duration: 0.3)) {
            slideDown = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.32) {
            showPopup = false
            slideDown = false
            changeStatusBarAppearance(darkMode: false)
        }
    }

    private func europeanStudentCardButtonTapped() {
        withAnimation(.easeInOut(duration: 0.08)) {
            europeanStudentCardButtonPressed = true
        }

        withAnimation(.easeInOut(duration: 0.08).delay(0.08)) {
            europeanStudentCardButtonPressed = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
            europeanStudentCardSlideDown = true
            showEuropeanStudentCard = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                withAnimation(.easeInOut(duration: 0.32)) {
                    europeanStudentCardSlideDown = false
                }
            }
        }
    }

    private func closeEuropeanStudentCard() {
        withAnimation(.easeInOut(duration: 0.22)) {
            europeanStudentCardSlideDown = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.24) {
            showEuropeanStudentCard = false
            europeanStudentCardSlideDown = false
        }
    }

    private func verifyButtonTapped() {
        isVerifying = true
        withAnimation(.easeInOut(duration: 0.6)) {
            validIDColor = Color("OutlineID")
            validIDTextColor = .white
            verifyButtonColor = Color("Verify").opacity(0.3)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(.easeInOut(duration: 0.6)) {
                validIDColor = Color("ValidID")
                validIDTextColor = .primary
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation(.easeInOut(duration: 0.6)) {
                validIDColor = Color("OutlineID")
                validIDTextColor = .white
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            withAnimation(.easeInOut(duration: 0.6)) {
                validIDColor = Color("ValidID")
                validIDTextColor = .primary
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
            withAnimation(.easeInOut(duration: 0.6)) {
                validIDColor = Color("OutlineID")
                validIDTextColor = .white
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation(.easeInOut(duration: 1.0)) {
                validIDColor = Color("ValidID")
                validIDTextColor = .primary
                isVerifying = false
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            withAnimation(.easeInOut(duration: 0.5)) {
                verifyButtonColor = Color("Verify")
            }
        }
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }

    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }

    private var timeZoneAbbreviation: String {
        TimeZone.current.abbreviation() ?? TimeZone.current.identifier
    }

    private func changeStatusBarAppearance(darkMode: Bool) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            withAnimation(.easeInOut(duration: 0.5)) {
                windowScene.windows.first?.overrideUserInterfaceStyle = darkMode ? .dark : .light
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(profileStore: StudentProfileStore())
    }
}

private struct ProfilePopupImageView: View {
    let profile: StudentProfile?

    var body: some View {
        if let imageData = profile?.profileImageData,
           let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .scaleEffect(profile?.profileImageScale ?? 1)
                .offset(
                    x: profile?.profileImageOffsetX ?? 0,
                    y: profile?.profileImageOffsetY ?? 0
                )
        } else {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(Color.gray.opacity(0.75))
                .padding(40)
        }
    }
}

private struct MainScreenLayout {
    let boxWidth: CGFloat
    let scale: CGFloat
    let profileImageSize: CGFloat
    let profileImageVerticalPadding: CGFloat
    let sectionSpacing: CGFloat
    let footerTopPadding: CGFloat
    let footerSpacing: CGFloat
    let footerFontSize: CGFloat
    let europeanStudentCardOverlayWidth: CGFloat
    let europeanButtonTopPadding: CGFloat

    init(size: CGSize) {
        boxWidth = min(370, max(330, size.width - 48))

        let widthScale = min(1, boxWidth / 370)
        let heightScale = min(1, max(0.86, size.height / 932))
        scale = min(widthScale, heightScale)

        profileImageSize = 100 * scale
        profileImageVerticalPadding = 23 * scale
        sectionSpacing = 23 * scale
        footerTopPadding = 20 * scale
        footerSpacing = 15 * scale
        footerFontSize = 13 * scale
        europeanStudentCardOverlayWidth = scale < 1 ? min(size.width - 36, boxWidth + 10) : boxWidth
        europeanButtonTopPadding = scale < 1 ? max(0, sectionSpacing - 14) : sectionSpacing
    }
}
