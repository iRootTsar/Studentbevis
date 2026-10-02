//
//  ValidIdView.swift
//  StudentbevisAppen
//
//  Created by Vladimirs Civilgins on 04/08/2024.
//

import SwiftUI

struct ValidIDView: View {
    let boxWidth: CGFloat
    var layoutScale: CGFloat = 1
    var verticalSpacing: CGFloat = 23
    let profile: StudentProfile
    @Binding var validIDColor: Color
    @Binding var validIDTextColor: Color
    @Binding var isVerifying: Bool
    @Binding var verifyButtonColor: Color // Add this line
    let verifyAction: () -> Void

    private var titleFontSize: CGFloat { 26 * layoutScale }
    private var subtitleFontSize: CGFloat { 12 * layoutScale }
    private var smallFontSize: CGFloat { 12 * layoutScale }

    var body: some View {
        VStack(spacing: 8 * layoutScale) {
            VStack(alignment: .center, spacing: 4 * layoutScale) {
                Text("Valid student ID")
                    .font(.system(size: titleFontSize, weight: .light))
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
            .padding(16 * layoutScale)
            .frame(width: boxWidth) // Apply the width to the valid student ID box
            .background(validIDColor)
            .foregroundColor(validIDTextColor)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("OutlineID"), lineWidth: 2)
            )
            .padding(.top, verticalSpacing)

            Button(action: verifyAction) {
                Text("Verify")
                    .font(.system(size: 22 * layoutScale, weight: .light))
                    .foregroundColor(.white)
                    .padding(16 * layoutScale)
                    .frame(width: boxWidth) // Apply the width to the Verify button
                    .background(verifyButtonColor)
                    .cornerRadius(30 * layoutScale)
            }
            .padding(.top, verticalSpacing)
        }
    }

    private var expiryDate: Date {
        StudentProfileCalculations.expiryDate(
            semester: profile.semester,
            academicYear: profile.academicYear
        )
    }
}
