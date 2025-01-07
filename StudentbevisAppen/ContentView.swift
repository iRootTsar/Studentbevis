//
//  ContentView.swift
//  StudentbevisAppen
//
//  Created by Vladimirs Civilgins on 04/08/2024.
//
import SwiftUI

struct ContentView: View {
    @State private var showPopup = false
    @State private var slideDown = false
    @State private var showSettingsMenu = false
    @State private var showTerms = false
    @State private var showLibraryCard = false
    @State private var isVerifying = false
    @State private var validIDColor = Color("ValidID")
    @State private var validIDTextColor = Color.primary
    @State private var verifyButtonColor = Color("Verify")
    @State private var isBlinking = false

    // Parameters for positioning and sizing
    let settingsButtonPaddingTop: CGFloat = 50
    let settingsButtonPaddingTrailing: CGFloat = 53
    let boxWidth: CGFloat = 370 // Change the width of the boxes here

    var body: some View {
        GeometryReader { geometry in
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
                        Image("profileImage")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .padding(.top, 23)
                            .padding(.bottom, 23)

                        Circle()
                            .fill(Color.white.opacity(isBlinking ? 0.3 : 0))
                            .frame(width: 100, height: 100)
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
                        InfoBoxView(boxWidth: boxWidth)
                            .padding(.horizontal)

                        ValidIDView(
                            boxWidth: boxWidth,
                            validIDColor: $validIDColor,
                            validIDTextColor: $validIDTextColor,
                            isVerifying: $isVerifying,
                            verifyButtonColor: $verifyButtonColor,
                            verifyAction: verifyButtonTapped
                        )
                        .padding(.horizontal)

                        VStack(spacing: 15) {
                            Text("Last updated: \(Date(), formatter: dateFormatter) at \(Date(), formatter: timeFormatter) (CET)")
                                .font(.footnote)
                            Text("Version: 4.0.0")
                                .font(.footnote)
                        }
                        .padding(.top, 20)
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
                            withAnimation(.easeInOut(duration: 0.6)) {
                                slideDown = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                    showPopup = false
                                    changeStatusBarAppearance(darkMode: false)
                                }
                            }
                        }

                    VStack {
                        Spacer()
                        ZStack {
                            if !slideDown {
                                Image("profileImage")
                                    .resizable()
                                    .scaledToFill()
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
                                                        withAnimation(.easeInOut(duration: 0.2)) {
                                                            slideDown = true
                                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                                showPopup = false
                                                                changeStatusBarAppearance(darkMode: false)
                                                            }
                                                        }
                                                    }
                                            }
                                            Spacer()
                                        }
                                    )
                                    .transition(.move(edge: .bottom))
                            }
                        }
                        .offset(y: slideDown ? geometry.size.height + geometry.size.height : 0)
                        Spacer(minLength: 300)
                    }
                    .transition(.move(edge: .bottom))
                }

                if showTerms {
                    TermsView(showTerms: $showTerms, showSettingsMenu: $showSettingsMenu)
                        .transition(.opacity)
                }
                if showLibraryCard {
                    LibraryCardView(showLibraryCard: $showLibraryCard, showSettingsMenu: $showSettingsMenu)
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
        ContentView()
    }
}
