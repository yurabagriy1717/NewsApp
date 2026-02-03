//
//  ProfileHeaderView.swift
//

import SwiftUI

struct ProfileHeaderView: View {
    @ObservedObject var vm: ProfileViewModel
    @State private var appear = false
    
    var body: some View {
        VStack {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: appear ? 100 : 0, height: appear ? 100 : 0)
                .foregroundStyle(.blue.gradient)
                .padding(.top, 32)
                .scaleEffect(appear ? 1 : 0.8)
                .animation(.spring(duration: 0.6), value: appear)
            Text("\(vm.firstName) \(vm.lastName)")
            Text("\(vm.email)")
                .font(.title2)
                .fontWeight(.bold)
                .opacity(appear ? 1 : 0)
                .animation(.easeIn.delay(0.3), value: appear)
        }
        .onAppear {
            appear = true
        }
    }
}



#Preview {
    ProfileHeaderView(
        vm: ProfileViewModel(
            settings: SettingsService(),
            sessionManager: SessionManagerImp(tokenStorage: TokenStorageImp()),
            profileRepository: ProfileRepositoryImpl(tokenStorage: TokenStorageImp())
        )
    )
}
