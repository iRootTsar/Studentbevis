//
//  InfoBox.swift
//  StudentbevisAppen
//
//  Created by Vladimirs Civilgins on 04/08/2024.
//

import SwiftUI

struct InfoBoxView: View {
    let boxWidth: CGFloat
    var layoutScale: CGFloat = 1
    let profile: StudentProfile

    private var titleFontSize: CGFloat { 20 * layoutScale }
    private var subtitleFontSize: CGFloat { 12 * layoutScale }
    private var smallFontSize: CGFloat { 12 * layoutScale }
    private var rowIconSize: CGFloat { 20 * layoutScale }
    private var hatIconSize: CGFloat { 23 * layoutScale }
    private var rowSpacing: CGFloat { 8 * layoutScale }
    private var stackSpacing: CGFloat { 10 * layoutScale }

    var body: some View {
        VStack(alignment: .leading, spacing: stackSpacing) {
            Text("\(profile.name) (\(age))")
                .font(.system(size: titleFontSize, weight: .light))
                .lineLimit(2)
                .minimumScaleFactor(0.8)

            HStack(alignment: .center, spacing: rowSpacing) {
                Image("Calendar")
                    .resizable()
                    .scaledToFit()
                    .frame(width: rowIconSize, height: rowIconSize)
                HStack {
                    Text("Date of birth: ")
                        .font(.system(size: subtitleFontSize, weight: .bold))
                    Text(StudentProfileCalculations.formattedDate(profile.dateOfBirth))
                        .font(.system(size: smallFontSize))
                }
            }
            HStack(alignment: .center, spacing: rowSpacing) {
                Image("StudentCard")
                    .resizable()
                    .scaledToFit()
                    .frame(width: rowIconSize, height: rowIconSize)
                HStack {
                    Text("Student number: ")
                        .font(.system(size: subtitleFontSize, weight: .bold))
                    Text(profile.studentNumber)
                        .font(.system(size: smallFontSize))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
            }
            HStack(alignment: .center, spacing: rowSpacing) {
                Image("EducationHat")
                    .resizable()
                    .scaledToFit()
                    .frame(width: hatIconSize, height: hatIconSize)
                HStack(alignment: .center, spacing: rowSpacing) {
                    Text("Institution: ")
                        .font(.system(size: subtitleFontSize, weight: .bold))
                    Text(profile.institutionName)
                        .font(.system(size: smallFontSize))
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)
                        .minimumScaleFactor(0.8)
                }
            }
        }
        .padding(.leading, -30 * layoutScale)
        .padding(16 * layoutScale)
        .frame(width: boxWidth) // Apply the width to the info box
        .background(Color("NavAndInfoColor"))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("Verify"), lineWidth: 2)
        )
    }

    private var age: Int {
        StudentProfileCalculations.age(from: profile.dateOfBirth)
    }
}
