import PhotosUI
import SwiftUI
import UIKit

struct StudentProfileEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var draft: StudentProfile
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var validationMessages: [String] = []
    @State private var showCamera = false
    @State private var cameraUnavailableMessage: String?
    @State private var dragStartOffset: CGSize?
    @State private var magnificationStartScale: Double?

    let isFirstTimeSetup: Bool
    let onSave: (StudentProfile) -> Void

    private let yearRange: [Int]

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

                        HStack {
                            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                                Text("Choose image")
                            }

                            Spacer()

                            Button("Take photo") {
                                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                                    showCamera = true
                                } else {
                                    cameraUnavailableMessage = "Camera is not available on this device."
                                }
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
            .onChange(of: selectedPhoto) { _, item in
                Task {
                    await loadPhoto(from: item)
                }
            }
            .sheet(isPresented: $showCamera) {
                CameraPicker { image in
                    setImage(image)
                }
            }
            .alert("Camera unavailable", isPresented: Binding(
                get: { cameraUnavailableMessage != nil },
                set: { if !$0 { cameraUnavailableMessage = nil } }
            )) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(cameraUnavailableMessage ?? "")
            }
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

    private func loadPhoto(from item: PhotosPickerItem?) async {
        guard let item,
              let data = try? await item.loadTransferable(type: Data.self),
              let image = UIImage(data: data) else {
            return
        }

        await MainActor.run {
            setImage(image)
        }
    }

    private func setImage(_ image: UIImage) {
        draft.profileImageData = image.jpegData(compressionQuality: 0.82)
        draft.profileImageScale = 1
        draft.profileImageOffsetX = 0
        draft.profileImageOffsetY = 0
    }
}
