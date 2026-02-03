//
//  ProfileViewModel.swift
//

import Foundation

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var profile: UserProfile?
    
    private let settings: SettingsServices
    private let sessionManager: SessionManager
    private let profileRepository: ProfileRepository
//    private let pushNotification: PushNotificationService
    weak var coordinator: AppCoorinator?
    
    
    init(
        settings: SettingsServices,
        sessionManager: SessionManager ,
        profileRepository: ProfileRepository/* ,*/
//        pushNotification: PushNotificationService
    ) {
        self.settings = settings
        self.sessionManager = sessionManager
        self.profileRepository = profileRepository
//        self.pushNotification = pushNotification
    }
    
    
    @MainActor func logout() {
        coordinator?.logout()
    }
    
    func loadProfile() async {
        do {
            let response = try await profileRepository.getProfile()
            
            self.profile = response
            self.firstName = response.first_name
            self.lastName = response.last_name
            self.email = sessionManager.user?.email ?? "not email"
        } catch {
            print("Failed to load profile:", error)
        }
    }
    
//    func togglePushNotifications() {
//        pushNotifications.toggle()
//        settings.setPushNotifications(pushNotifications)
//    }
    
//    func resetSettings() {
//        settings.resetSettings()
//        pushNotifications = false
//    }
}
