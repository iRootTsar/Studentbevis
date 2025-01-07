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

    var body: some Scene {
        WindowGroup {
            if isLoading {
                LoadingView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isLoading = false
                        }
                    }
            } else {
                ContentView()
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

