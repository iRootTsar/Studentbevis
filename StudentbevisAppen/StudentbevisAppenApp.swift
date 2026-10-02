//
//  StudentbevisAppenApp.swift
//  StudentbevisAppen
//
//  Created by Vladimirs Civilgins on 04/08/2024.
//

import SwiftUI

@main
struct StudentbevisAppenApp: App {
    @State private var isLoading = true
    @StateObject private var profileStore = StudentProfileStore()

    var body: some Scene {
        WindowGroup {
            if isLoading {
                LoadingView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isLoading = false
                        }
                    }
            } else if profileStore.requiresSetup {
                StudentProfileEditorView(
                    profile: nil,
                    isFirstTimeSetup: true
                ) { profile in
                    profileStore.save(profile)
                }
            } else {
                ContentView(profileStore: profileStore)
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
}
