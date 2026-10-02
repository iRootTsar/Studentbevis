//
//  InfoBox.swift
//  StudentbevisAppen
//
//  Created by Vladimirs Civilgins on 04/08/2024.
//

import SwiftUI

struct InfoBoxView: View {
    let boxWidth: CGFloat
    let profile: StudentProfile
    // Font sizes
    let titleFontSize: CGFloat = 21
    let subtitleFontSize: CGFloat = 12
    let smallFontSize: CGFloat = 12

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("\(profile.name) (\(age))")
                .font(.system(size: titleFontSize))
                .lineLimit(2)
                .minimumScaleFactor(0.8)

            HStack(alignment: .center, spacing: 8) {
                Image("Calendar")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                HStack {
                    Text("Date of birth: ")
                        .font(.system(size: subtitleFontSize, weight: .bold))
                    Text(StudentProfileCalculations.formattedDate(profile.dateOfBirth))
                        .font(.system(size: smallFontSize))
                }
            }
            HStack(alignment: .center, spacing: 8) {
                Image("StudentCard")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                HStack {
                    Text("Student number: ")
                        .font(.system(size: subtitleFontSize, weight: .bold))
                    Text(profile.studentNumber)
                        .font(.system(size: smallFontSize))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
            }
            HStack(alignment: .center, spacing: 8) {
                Image("EducationHat")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 23, height: 23)
                HStack(alignment: .center, spacing: 8) {
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
        .padding(.leading, -30)
        .padding()
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
