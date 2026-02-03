//
//  AppCoorinator.swift
//

import SwiftUI

@MainActor
final class AppCoorinator: ObservableObject {
    @Published var root: AppRoute = .welcome
    @Published var path: [AppRoute] = []
    
    private let session: SessionManager

    init(session: SessionManager) {
        self.session = session
        restoreSession()
    }
    
    func setRoot(_ route: AppRoute) {
        root = route
        path.removeAll()
    }
    
    func push(_ route: AppRoute) {
        path.append(route)
    }
    
    func pop() {
        _ = path.popLast()
    }
    
    func goToLogin() {
        setRoot(.login)
    }
    
    func goToNews() {
        setRoot(.news)
    }
    
    func goToRegister() {
        setRoot(.register)
    }

    
    func logout() {
        session.logout()
        setRoot(.login)
    }
    
    func didAuthorize(_ response: AuthResponse) {
        session.startSession(response: response)
        setRoot(.news)
    }
    
    func restoreSession() {
        session.restoreSession()
        if session.isAuthenticated {
            setRoot(.news)
        } else {
            setRoot(.login)
        }
    }
    
}

