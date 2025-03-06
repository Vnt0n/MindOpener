//
//  LaunchView.swift
//  MindOpener
//
//  Created by Vnt0n on 06/03/2025.
//


import SwiftUI

struct LaunchView: View {
    @State private var isActive = false

    var body: some View {
        ZStack {
            if isActive {
                FirstView()
                    .transition(.opacity)
            } else {
                VStack {
                    Image("LaunchIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                        .cornerRadius(20)
                    Text("MindOpener")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 20)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground))
                .transition(.opacity)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeInOut(duration: 1)) {
                    isActive = true
                }
            }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
