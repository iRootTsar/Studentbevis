import Foundation

final class StudentProfileStore: ObservableObject {
    @Published private(set) var profile: StudentProfile?

    private let userDefaults: UserDefaults
    private let profileKey = "studentProfile"
    private let hasCompletedSetupKey = "hasCompletedSetup"

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        profile = Self.loadProfile(from: userDefaults, key: profileKey)
    }

    var hasCompletedSetup: Bool {
        userDefaults.bool(forKey: hasCompletedSetupKey)
    }

    var requiresSetup: Bool {
        guard hasCompletedSetup, let profile else {
            return true
        }

        return !profile.isValid
    }

    func save(_ profile: StudentProfile) {
        let profileToSave = profile.normalizedForSaving

        guard profileToSave.isValid,
              let data = try? JSONEncoder().encode(profileToSave) else {
            return
        }

        userDefaults.set(data, forKey: profileKey)
        userDefaults.set(true, forKey: hasCompletedSetupKey)
        self.profile = profileToSave
    }

    func reset() {
        userDefaults.removeObject(forKey: profileKey)
        userDefaults.set(false, forKey: hasCompletedSetupKey)
        profile = nil
    }

    private static func loadProfile(from userDefaults: UserDefaults, key: String) -> StudentProfile? {
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }

        return try? JSONDecoder().decode(StudentProfile.self, from: data)
    }
}
