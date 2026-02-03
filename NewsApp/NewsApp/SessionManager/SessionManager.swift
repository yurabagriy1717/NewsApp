//
//  SessionManager.swift
//

import SwiftUI

@MainActor
protocol SessionManager {
    var isAuthenticated: Bool { get }
    var user: SupabaseUser? { get }
    func startSession(response: AuthResponse)
    func logout()
    func restoreSession()
    func updateToken(access: String, refresh: String?)
}

@MainActor
final class SessionManagerImp: SessionManager, ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var user: SupabaseUser?
    
    private let tokenStorage: TokenStorage
    
    init(
        tokenStorage: TokenStorage
    ) {
        self.tokenStorage = tokenStorage
    }
    
    func startSession(response: AuthResponse) {
        tokenStorage.save(response.access_token, for: "access_token")
        
        if let refresh = response.refresh_token {
            tokenStorage.save(refresh, for: "refresh_token")
        }
        
        if let id = response.user?.id {
            tokenStorage.save(id, for: "user_id")
        }
        
        if let email = response.user?.email {
            tokenStorage.save(email, for: "email")
        }
        
        user = response.user
        isAuthenticated = true
        
    }
    
    func updateToken(access: String, refresh: String?) {
        tokenStorage.save(access, for: "access_token")
        if let refresh = refresh {
            tokenStorage.save(refresh, for: "refresh_token")
        }
    }
    
    func logout() {
        tokenStorage.clear()
        isAuthenticated = false
        user = nil
    }
    
    func restoreSession() {
        let accessToken = tokenStorage.get("access_token")
        let id = tokenStorage.get("user_id")
        let email = tokenStorage.get("email")
        
        guard let accessToken, let id, let email else {
            isAuthenticated = false
            return
        }
        self.user = SupabaseUser(id: id, email: email)
        self.isAuthenticated = true
    }
    
    
}
