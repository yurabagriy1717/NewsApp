//
//  LoginViewModel.swift
//

import Foundation

@MainActor
class LoginViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    
    private let authService: AuthService
    private let sessionManager: SessionManager
    weak var coordinator: AppCoorinator?
    
    init(
        authService: AuthService ,
        sessionManager: SessionManager ,
    ) {
        self.authService = authService
        self.sessionManager = sessionManager
    }
    
    func login() async {
        errorMessage = ""
        if let validation = validateRegister() {
            errorMessage = validation
            return
        }
        isLoading = true
        do {
            let response = try await authService.login(email: email, password: password)
            coordinator?.didAuthorize(response)
            
        } catch {
            errorMessage = "Invalid credentials"
        }
        isLoading = false
    }
    
    private func validateRegister() -> String? {
        if email.isEmpty || password.isEmpty {
            return "Fill all fields"
        }
        if !email.contains("@") {
            return "Email invalid"
        }
        if password.count < 6 {
            return "Password too short"
        }
        return nil
    }
    
}


