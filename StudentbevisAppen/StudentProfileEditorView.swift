import SwiftUI
import UIKit

struct StudentProfileEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var draft: StudentProfile
    @State private var validationMessages: [String] = []
    @State private var activeImagePicker: ImagePickerSource?
    @State private var imageImportMessage: String?
    @State private var dragStartOffset: CGSize?
    @State private var magnificationStartScale: Double?

    let isFirstTimeSetup: Bool
    let onSave: (StudentProfile) -> Void

    private let yearRange: [Int]

    private enum ImagePickerSource: String, Identifiable {
        case photoLibrary
        case camera
        case files

        var id: String {
            rawValue
        }
    }

    init(
        profile: StudentProfile?,
        isFirstTimeSetup: Bool,
        onSave: @escaping (StudentProfile) -> Void
    ) {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        _draft = State(initialValue: profile ?? StudentProfile.empty(calendar: calendar))
        self.isFirstTimeSetup = isFirstTimeSetup
        self.onSave = onSave
        yearRange = Array((currentYear - 2)...(currentYear + 4))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Profile image") {
                    VStack(spacing: 14) {
                        adjustableImagePreview

                        VStack(spacing: 10) {
                            HStack {
                                Button("Choose from Photos") {
                                    activeImagePicker = .photoLibrary
                                }

                                Spacer()

                                Button("Choose from Files") {
                                    activeImagePicker = .files
                                }
                            }

                            HStack {
                                Button("Take photo") {
                                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                                        activeImagePicker = .camera
                                    } else {
                                        imageImportMessage = "Camera is not available on this device."
                                    }
                                }

                                Spacer()
                            }
                        }

                        Button("Remove current image", role: .destructive) {
                            draft.profileImageData = nil
                            draft.profileImageScale = 1
                            draft.profileImageOffsetX = 0
                            draft.profileImageOffsetY = 0
                        }
                        .disabled(draft.profileImageData == nil)
                    }
                    .frame(maxWidth: .infinity)
                }

                Section("Student") {
                    TextField("Name", text: $draft.name)
                        .textContentType(.name)

                    DatePicker(
                        "Date of birth",
                        selection: $draft.dateOfBirth,
                        in: ...Date(),
                        displayedComponents: .date
                    )

                    TextField("Student number", text: $draft.studentNumber)
                        .keyboardType(.default)
                        .textInputAutocapitalization(.never)
                }

                Section("Institution") {
                    TextField("University / institution", text: $draft.institutionName, axis: .vertical)
                        .lineLimit(1...3)
                }

                Section("Semester") {
                    Picker("Semester", selection: $draft.semester) {
                        ForEach(Semester.allCases) { semester in
                            Text(semester.displayName).tag(semester)
                        }
                    }
                    .pickerStyle(.segmented)

                    Picker("Academic year", selection: $draft.academicYear) {
                        ForEach(yearRange, id: \.self) { year in
                            Text(String(year)).tag(year)
                        }
                    }

                    HStack {
                        Text("Expires")
                        Spacer()
                        Text(StudentProfileCalculations.formattedDate(expiryDate))
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Version") {
                    TextField("Version", text: $draft.version)
                        .textInputAutocapitalization(.never)
                }

                if !validationMessages.isEmpty {
                    Section {
                        ForEach(validationMessages, id: \.self) { message in
                            Text(message)
                                .foregroundStyle(.red)
                        }
                    }
                }
            }
            .navigationTitle(isFirstTimeSetup ? "Profile setup" : "Profile settings")
            .toolbar {
                if !isFirstTimeSetup {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                    }
                }
            }
            .interactiveDismissDisabled(isFirstTimeSetup)
            .fullScreenCover(item: $activeImagePicker) { pickerSource in
                imagePickerView(for: pickerSource)
            }
            .alert("Image unavailable", isPresented: Binding(
                get: { imageImportMessage != nil },
                set: { if !$0 { imageImportMessage = nil } }
            )) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(imageImportMessage ?? "")
            }
        }
    }

    @ViewBuilder
    private func imagePickerView(for pickerSource: ImagePickerSource) -> some View {
        switch pickerSource {
        case .photoLibrary:
            PhotoLibraryPicker(
                onImagePicked: setImage,
                onError: showImageImportError
            )
        case .camera:
            CameraPicker(sourceType: .camera) { image in
                setImage(image)
            }
        case .files:
            ImageDocumentPicker(
                onImagePicked: setImage,
                onError: showImageImportError
            )
        }
    }

    private var adjustableImagePreview: some View {
        ProfileImageView(
            imageData: draft.profileImageData,
            scale: draft.profileImageScale,
            offsetX: draft.profileImageOffsetX,
            offsetY: draft.profileImageOffsetY,
            size: 150
        )
        .gesture(
            DragGesture()
                .onChanged { value in
                    let startOffset = dragStartOffset ?? CGSize(
                        width: draft.profileImageOffsetX,
                        height: draft.profileImageOffsetY
                    )
                    dragStartOffset = startOffset
                    draft.profileImageOffsetX = startOffset.width + value.translation.width
                    draft.profileImageOffsetY = startOffset.height + value.translation.height
                }
                .onEnded { _ in
                    dragStartOffset = nil
                }
        )
        .gesture(
            MagnificationGesture()
                .onChanged { value in
                    let startScale = magnificationStartScale ?? draft.profileImageScale
                    magnificationStartScale = startScale
                    draft.profileImageScale = min(max(startScale * value, 1), 3)
                }
                .onEnded { _ in
                    magnificationStartScale = nil
                }
        )
    }

    private var expiryDate: Date {
        StudentProfileCalculations.expiryDate(
            semester: draft.semester,
            academicYear: draft.academicYear
        )
    }

    private func save() {
        validationMessages = StudentProfileValidator.validate(draft)

        guard validationMessages.isEmpty else {
            return
        }

        onSave(draft)
        dismiss()
    }

    private func setImage(_ image: UIImage) {
        draft.profileImageData = image.jpegData(compressionQuality: 0.82)
        draft.profileImageScale = 1
        draft.profileImageOffsetX = 0
        draft.profileImageOffsetY = 0
    }

    private func showImageImportError(_ message: String) {
        imageImportMessage = message
    }
}
