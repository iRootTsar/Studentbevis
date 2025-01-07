//
//  LoadingView.swift
//  StudentbevisAppen
//
//  Created by Vladimirs Civilgins on 04/08/2024.
//

import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            Color("NavAndInfoColor")
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                ZStack {
                    ForEach(0..<8) { index in
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray)
                            .frame(width: 6, height: 15)
                            .offset(y: -15)
                            .rotationEffect(Angle(degrees: Double(index) / 8.0 * 360.0))
                            .opacity(isAnimating ? 1.0 : 0.3)
                            .animation(
                                Animation.easeInOut(duration: 1)
                                    .repeatForever()
                                    .delay(Double(index) * 0.15),
                                value: isAnimating
                            )
                    }
                }
                .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                .animation(Animation.linear(duration: 2).repeatForever(autoreverses: false), value: isAnimating)
                .onAppear {
                    isAnimating = true
                }

                Spacer()
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
