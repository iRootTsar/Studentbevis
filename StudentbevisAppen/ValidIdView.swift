//
//  ValidIdView.swift
//  StudentbevisAppen
//
//  Created by Vladimirs Civilgins on 04/08/2024.
//

import SwiftUI

struct ValidIDView: View {
    let boxWidth: CGFloat
    let profile: StudentProfile
    @Binding var validIDColor: Color
    @Binding var validIDTextColor: Color
    @Binding var isVerifying: Bool
    @Binding var verifyButtonColor: Color // Add this line
    let verifyAction: () -> Void

    // Font sizes
    let titleFontSize: CGFloat = 26
    let subtitleFontSize: CGFloat = 12
    let smallFontSize: CGFloat = 12

    var body: some View {
        VStack(spacing: 8) {
            VStack(alignment: .center, spacing: 4) {
                Text("Valid student ID")
                    .font(.system(size: titleFontSize))
                Text(StudentProfileCalculations.semesterDisplayName(
                    semester: profile.semester,
                    academicYear: profile.academicYear
                ))
                    .font(.system(size: subtitleFontSize)) // Smaller font
                HStack {
                    Text("Expires:")
                        .font(.system(size: subtitleFontSize, weight: .bold))
                    Text(StudentProfileCalculations.formattedDate(expiryDate))
                        .font(.system(size: smallFontSize)) // Smaller font
                }
            }
            .padding()
            .frame(width: boxWidth) // Apply the width to the valid student ID box
            .background(validIDColor)
            .foregroundColor(validIDTextColor)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("OutlineID"), lineWidth: 2)
            )
            .padding(.top, 23)

            Button(action: verifyAction) {
                Text("Verify")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: boxWidth) // Apply the width to the Verify button
                    .background(verifyButtonColor)
                    .cornerRadius(30)
            }
            .padding(.top, 23)
        }
    }

    private var expiryDate: Date {
        StudentProfileCalculations.expiryDate(
            semester: profile.semester,
            academicYear: profile.academicYear
        )
    }
}
