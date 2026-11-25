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

    private var titleFontSize: CGFloat { 22 * layoutScale }
    private var detailFontSize: CGFloat { 12 * layoutScale + 2 }

    var body: some View {
        VStack(spacing: 8 * layoutScale) {
            VStack(alignment: .center, spacing: 4 * layoutScale) {
                Text("Valid student ID")
                    .font(.system(size: titleFontSize, weight: .medium))
                Text(StudentProfileCalculations.semesterDisplayName(
                    semester: profile.semester,
                    academicYear: profile.academicYear
                ))
                    .font(.system(size: detailFontSize))
                HStack {
                    Text("Expires:")
                        .font(.system(size: detailFontSize, weight: .bold))
                    Text(StudentProfileCalculations.formattedDate(expiryDate))
                        .font(.system(size: detailFontSize))
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
                    .font(.system(size: 22 * layoutScale + 2, weight: .light))
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
