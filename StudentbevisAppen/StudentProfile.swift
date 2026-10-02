import Foundation

struct StudentProfile: Codable, Equatable {
    var name: String
    var dateOfBirth: Date
    var studentNumber: String
    var institutionName: String
    var semester: Semester
    var academicYear: Int
    var version: String
    var profileImageData: Data?
    var profileImageScale: Double
    var profileImageOffsetX: Double
    var profileImageOffsetY: Double

    var isValid: Bool {
        StudentProfileValidator.validate(self).isEmpty
    }

    static func empty(calendar: Calendar = .current) -> StudentProfile {
        StudentProfile(
            name: "",
            dateOfBirth: Date(),
            studentNumber: "",
            institutionName: "",
            semester: .autumn,
            academicYear: calendar.component(.year, from: Date()),
            version: "",
            profileImageData: nil,
            profileImageScale: 1,
            profileImageOffsetX: 0,
            profileImageOffsetY: 0
        )
    }
}

enum StudentProfileValidator {
    static func validate(
        _ profile: StudentProfile,
        today: Date = Date(),
        calendar: Calendar = .current
    ) -> [String] {
        var messages: [String] = []

        if profile.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            messages.append("Name is required.")
        }

        if profile.institutionName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            messages.append("University / institution is required.")
        }

        if profile.studentNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            messages.append("Student number is required.")
        }

        if profile.version.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            messages.append("Version is required.")
        }

        if calendar.startOfDay(for: profile.dateOfBirth) > calendar.startOfDay(for: today) {
            messages.append("Date of birth cannot be in the future.")
        }

        let currentYear = calendar.component(.year, from: today)
        if !(currentYear - 10...currentYear + 10).contains(profile.academicYear) {
            messages.append("Academic year must be within a reasonable range.")
        }

        return messages
    }
}
