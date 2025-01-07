//
//  DropdownButton.swift
//  StudentbevisAppen
//
//  Created by Vladimirs Civilgins on 04/08/2024.
//

import SwiftUI

struct DropdownButton: View {
    @Binding var showSettingsMenu: Bool

    var body: some View {
        VStack(spacing: 4) {
            Circle()
                .stroke(Color("Verify"), lineWidth: 2)
                .frame(width: 5, height: 5)
            Circle()
                .stroke(Color("Verify"), lineWidth: 2)
                .frame(width: 5, height: 5)
            Circle()
                .stroke(Color("Verify"), lineWidth: 2)
                .frame(width: 5, height: 5)
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                showSettingsMenu.toggle()
            }
        }
    }
}
