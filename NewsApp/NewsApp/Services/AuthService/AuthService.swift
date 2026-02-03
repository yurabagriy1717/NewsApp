//
//  AuthService.swift
//

import Foundation

protocol AuthService {
    func register(email: String, password: String) async throws -> AuthResponse
    func login(email: String, password: String) async throws -> AuthResponse
    func refreshToken(refreshToken: String) async throws -> AuthResponse
}

final class AuthServiceImp: AuthService {
    
    private let sessionManager: SessionManager
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
    }
    
    func register(email: String, password: String) async throws -> AuthResponse {
        guard let url = URL(string: "\(SupabaseConstants.projectURL)/auth/v1/signup") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(SupabaseConstants.anonKey, forHTTPHeaderField: "apikey")
        
        let body = ["email" : email
                    ,"password" : password
        ]
        
        request.httpBody = try JSONEncoder().encode(body)
        let(data,response) = try await URLSession.shared.data(for: request)
        let httpResponse = response as! HTTPURLResponse
        guard (200...299).contains(httpResponse.statusCode) else {
            print("Supabase error:", String(data: data, encoding: .utf8)!)
            throw AuthError.registrationFailed
        }
        
        return try JSONDecoder().decode(AuthResponse.self, from: data)
    }
    
    func login(email: String, password: String) async throws -> AuthResponse {
        guard let url = URL(string: "\(SupabaseConstants.projectURL)/auth/v1/token?grant_type=password") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(SupabaseConstants.anonKey, forHTTPHeaderField: "apikey")
        
        let body = [
            "email" : email,
            "password" : password
        ]
        
        request.httpBody = try JSONEncoder().encode(body)
        let(data,response) = try await URLSession.shared.data(for: request)
        let httpResponse = response as! HTTPURLResponse
        guard (200...299).contains(httpResponse.statusCode) else {
            print("Supabase error:", String(data: data, encoding: .utf8)!)
            throw AuthError.registrationFailed
        }
        
        return try JSONDecoder().decode(AuthResponse.self, from: data)
    }
    
    func refreshToken(refreshToken: String) async throws -> AuthResponse {
        guard let url = URL(string: "\(SupabaseConstants.projectURL)/auth/v1/token?grant_type=refresh_token") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(SupabaseConstants.anonKey, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(refreshToken)", forHTTPHeaderField: "Authorization")
        
        let(data,response) = try await URLSession.shared.data(for: request)
        let httpResponse = response as! HTTPURLResponse
        guard (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        let result = try JSONDecoder().decode(AuthResponse.self, from: data)
        await sessionManager.updateToken(access: result.access_token, refresh: result.refresh_token)
        return result
    }

    
}

enum AuthError: Error {
    case invalidCredentials
    case registrationFailed
}
