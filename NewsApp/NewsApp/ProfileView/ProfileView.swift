//
//  ProfileView.swift
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var vm = AppDIContainer.shared.makeProfileViewModel()
    @EnvironmentObject var coordinator: AppCoorinator
    
    var body: some View {
        VStack {
            Button {
                vm.logout()
            } label: {
                Text("Log out")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .font(.headline)
            .cornerRadius(14)
            .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
            ProfileHeaderView(vm: vm)
            ProfileSettingsView(vm: vm)
        
        }
        .task {
            await vm.loadProfile()
        }
        .navigationTitle("Profile")
        .listStyle(.insetGrouped)
        .onAppear {
            vm.coordinator = coordinator
        }
    }
}

#Preview {
    ProfileView()
}
