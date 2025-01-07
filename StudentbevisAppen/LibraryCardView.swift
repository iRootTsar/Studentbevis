//
//  LibraryCardView.swift
//  StudentbevisAppen
//
//  Created by Vladimirs Civilgins on 04/08/2024.
//

import SwiftUI

struct LibraryCardView: View {
    @Binding var showLibraryCard: Bool
    @Binding var showSettingsMenu: Bool

    var body: some View {
        ZStack {
            Color.white.opacity(0.01)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    showLibraryCard = false
                    showSettingsMenu = false
                }

            VStack {
                Spacer(minLength: 100)
                VStack(alignment: .center, spacing: 20) {
                    Text("My library card")
                        .font(.system(size: 27)) // Custom font and size for title
                        .padding(.bottom, 5)
                        .padding(.top, 10)

                    HStack(spacing: 5) {
                        ForEach(0..<19, id: \.self) { _ in
                            Rectangle()
                            .fill(Color.black)
                            .frame(width: CGFloat.random(in: 0.5...6), height: 100)
                            }
                        }
                    .frame(width: 230)

                    Text("104602")
                        .font(.system(size: 19))

                    Text("Institution:")
                        .font(.system(size: 12, weight: .bold))
                        .padding(.top, 5)

                    Text("Norwegian University of Science and Technology")
                        .font(.system(size: 13))
                        

                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showLibraryCard = false
                            showSettingsMenu = false
                        }
                    }) {
                        Text("Close")
                            .font(.title2)
                            .foregroundColor(Color("Backgroundscreen"))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("Verify"))
                            .cornerRadius(30)
                    }
                    .padding(.bottom, 15) // Adjust padding for close button
                }
                .padding()
                .background(Color("Backgroundscreen"))
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color("Verify"), lineWidth: 2)
                )
                .padding([.leading, .trailing], 25)
                .padding(.bottom, 290)
                Spacer()
            }
            .onTapGesture {
                // This tap gesture prevents the background tap gesture from closing the LibraryCardView
            }
        }
    }
}
