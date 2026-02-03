//
//  ProfileSettingsView.swift
//

import SwiftUI

struct ProfileSettingsView: View {
    @ObservedObject var vm: ProfileViewModel
    @EnvironmentObject var coordinator: AppCoorinator
    @EnvironmentObject var theme: ThemeViewModel
    
    var body: some View {   
        List {
            Section("theme") {
                Toggle(isOn: $theme.isDarkMode) {
                    Label("Dark Mode", systemImage: "moon.fill")
                }
            }
            
//            Section("Notifications") {
//                Toggle(isOn: $vm.pushNotifications) {
//                    Label("Push Notifications", systemImage: "bell.fill")
//                }
//            }
            
            Section("Language") {
                Button {
                    coordinator.push(.languageView)
                } label: {
                    Label("Language", systemImage: "globe")
                }
            }
            
            Section("About APP") {
                Button {
                    coordinator.push(.aboutView)
                } label: {
                    Label("About", systemImage: "info.circle")
                }
            }
            
            Section {
                Button(role: .destructive) {
//                    $vm.resetSettings
                    theme.isDarkMode = false
                } label: {
                    Label("Reset Settings", systemImage: "arrow.counterclockwise")
                }
                
            }
            
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(Color(.systemGroupedBackground))
        
    }
}


#Preview {
    ProfileSettingsView(
        vm: ProfileViewModel(
            settings: SettingsService(),
            sessionManager: SessionManagerImp(tokenStorage: TokenStorageImp()), profileRepository: ProfileRepositoryImpl(tokenStorage: TokenStorageImp())
        )
    )
    .environmentObject(AppCoorinator(session: SessionManagerImp(tokenStorage: TokenStorageImp())))
    .environmentObject(ThemeViewModel(settings: SettingsService()))
}
