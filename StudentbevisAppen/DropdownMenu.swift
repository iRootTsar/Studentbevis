//
//  DropdownMenu.swift
//  StudentbevisAppen
//
//  Created by Vladimirs Civilgins on 04/08/2024.
//

import SwiftUI

struct DropdownMenu: View {
    @Binding var showTerms: Bool
    @Binding var showLibraryCard: Bool

    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        Button(action: {
                            withAnimation {
                                showLibraryCard = true
                            }
                        }) {
                            HStack {
                                Text("Library Card")
                                    .foregroundColor(.black)
                                Spacer()
                                Image("BarCode")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 15)
                            .background(Color.white.opacity(0.5))
                        }
                        Divider()
                            .background(Color.black)
                            .padding(.horizontal, 8)
                        Button(action: {
                            withAnimation {
                                showTerms = true
                            }
                        }) {
                            HStack {
                                Text("Terms")
                                    .foregroundColor(.black)
                                Spacer()
                                Image("Terms")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 15)
                            .background(Color.white.opacity(0.5))
                        }
                        Divider()
                            .background(Color.black)
                            .padding(.horizontal, 8)
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                let url = URL(string: "https://sikt.no/studentbevis-pa-mobil/personvernerklaering")!
                                UIApplication.shared.open(url)
                            }
                        }) {
                            HStack {
                                Text("Privacy")
                                    .foregroundColor(.black)
                                Spacer()
                                Image("Lock")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 15)
                            .background(Color.white.opacity(0.5)) // Blink effect
                            .cornerRadius(5)
                        }
                        Divider()
                            .background(Color.black)
                            .padding(.horizontal, 8)
                        Button(action: {
                            exit(0)
                        }) {
                            HStack {
                                Text("Log out")
                                    .foregroundColor(Color("LogoutColor"))
                                Spacer()
                                Image("Logout")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 15)
                        }
                        Divider()
                            .background(Color.black)
                            .padding(.horizontal, 8)
                    }
                    .frame(width: 200) // Default menu width
                    .frame(height: 250)
                }
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("Verify"), lineWidth: 2)
                )
                .shadow(radius: 10)
            }
            Spacer()
        }
        .transition(.opacity)
    }
}

