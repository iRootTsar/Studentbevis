//
//  TermsView.swift
//  StudentbevisAppen
//
//  Created by Vladimirs Civilgins on 04/08/2024.
//

import SwiftUI

struct TermsView: View {
    @Binding var showTerms: Bool
    @Binding var showSettingsMenu: Bool

    var body: some View {
        ZStack {
            Color.black.opacity(0.01)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showTerms = false
                        showSettingsMenu = false
                    }
                }

            VStack {
                Spacer(minLength: 120)
                VStack(alignment: .leading, spacing: 30) {
                    Text("Terms")
                        .font(.system(size: 26)) // Custom font and size for title
                        .padding(.bottom, 10)
                        .padding(.top, 20)
                        .padding(.leading, 20)

                    ScrollView {
                        VStack(alignment: .leading) {
                            Text("""
                            The app will display information about your name, place of study and whether you have paid the semester fee and register for the semester. The app will also display a picture of you, which the institution has taken for use for the student card. The app serves as a student ID among other things at student welfare organizations and public transport companies in Norway. If the app does not display a picture of you, you must bring valid photo ID.
                            """)
                                .font(.system( size: 17)) // Custom font size
                            Text("\n") + // Newline to separate text and link
                            Text("""
                            The first time you use the app, the app must be connected to the internet to be able to download information. The information is stored locally on the phone and you do not need to be online to use the app.
                            """)
                                .font(.system(size: 17)) // Custom font size
                            Text("\n") + // Newline to separate text and link
                            Text("""
                            Should the phone run out of power or for other reasons not work, you must prove student status with semester receipt and valid ID.
                            """)
                                .font(.system(size: 17)) // Custom font size
                            Text("\n") + // Newline to separate text and link
                            Text("The institution is not responsible for fines, misuse and the like ")
                                .font(.system(size: 17)) // Custom font size
                            + Text("[\nRead more about the digital student ID.](https://sikt.no/studentbevis-pa-mobil)")
                                .font(.system(size: 17))
                                .foregroundColor(.blue)
                                .underline()
                                .bold()
                        }
                        .padding(.leading, 20)
                        .padding(.trailing, 35)
                    }

                    Spacer()

                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showTerms = false
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
                    .padding(.bottom, 20)
                }
                .padding()
                .background(Color("Backgroundscreen"))
                .cornerRadius(25)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("Verify"), lineWidth: 2)
                )
                .padding([.leading, .trailing], 25)
                .padding(.bottom, 20)
                Spacer()
            }
            .onTapGesture {
                // This tap gesture prevents the background tap gesture from closing the TermsView
            }
        }
    }
}
