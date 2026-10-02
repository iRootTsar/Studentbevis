import Foundation

enum Semester: String, Codable, CaseIterable, Identifiable {
    case spring
    case autumn

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .spring:
            return "Spring"
        case .autumn:
            return "Autumn"
        }
    }
}
