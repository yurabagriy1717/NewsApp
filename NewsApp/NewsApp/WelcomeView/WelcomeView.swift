//
//  WelcomeView.swift
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var coordinator: AppCoorinator
    @ObservedObject var vm: WelcomeViewModel
    @AppStorage("hasSeenWelcome") private var hasSeenWelcome = false

    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "newspaper.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 120)
                .foregroundColor(.blue)
            Button {
                coordinator.setRoot(.login)
            } label: {
                Text("Next")
                    .buttonStyle(.borderedProminent)
            }
            Spacer()
        }
        .padding()
        .onAppear {
            vm.onContinue = {
                hasSeenWelcome = true
            }
        }
    }
}


#Preview {
    WelcomeView(vm: WelcomeViewModel())
}
