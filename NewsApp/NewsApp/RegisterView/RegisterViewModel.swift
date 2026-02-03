//
//  RegisterViewModel.swift
//

import Foundation

@MainActor
class RegisterViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var name: String = ""
    @Published var surname: String = ""
    @Published var confirmPassword: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let authService: AuthService
    weak var coordinator: AppCoorinator?
    private let sessionManager: SessionManager
    private let profileRepository: ProfileRepository
    
    init(
        authService: AuthService ,
        sessionManager: SessionManager ,
        profileRepository: ProfileRepository
    ) {
        self.authService = authService
        self.sessionManager = sessionManager
        self.profileRepository = profileRepository
    }
    
    func register() async {
        errorMessage = ""
        if let validation = validateRegister() {
            errorMessage = validation
            return
        }
        isLoading = true
        do {
            let response = try await authService.register(email: email, password: password)
            sessionManager.startSession(response: response)
            let profile = try await profileRepository.createProfile(firstName: name, lastName: surname)
            coordinator?.setRoot(.news)
            
        } catch {
            errorMessage = "Invalid credentials"
        }
        isLoading = false
    }
        
    private func validateRegister() -> String? {
           if email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
               return "Fill all fields"
           }
           if !email.contains("@") {
               return "Email invalid"
           }
           if password.count < 6 {
               return "Password too short"
           }
           if password != confirmPassword {
               return "Passwords do not match"
           }
           return nil
       }
    
    func setCoordinator(_ coordinator: AppCoorinator) {
            self.coordinator = coordinator
        }
    
}
