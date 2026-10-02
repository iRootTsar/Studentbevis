import Foundation

enum StudentProfileCalculations {
    static func age(
        on date: Date = Date(),
        from dateOfBirth: Date,
        calendar: Calendar = .current
    ) -> Int {
        calendar.dateComponents([.year], from: dateOfBirth, to: date).year ?? 0
    }

    static func expiryDate(
        semester: Semester,
        academicYear: Int,
        calendar: Calendar = .current
    ) -> Date {
        var components = DateComponents()
        components.calendar = calendar

        switch semester {
        case .spring:
            components.year = academicYear
            components.month = 8
            components.day = 31
        case .autumn:
            components.year = academicYear + 1
            components.month = 1
            components.day = 31
        }

        return calendar.date(from: components) ?? Date()
    }

    static func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_GB")
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }

    static func semesterDisplayName(semester: Semester, academicYear: Int) -> String {
        "\(semester.displayName) \(academicYear)"
    }
}
