//
//  ProfileRepostory.swift
//

import Foundation

protocol ProfileRepository {
    func createProfile(firstName: String, lastName: String) async throws -> UserProfile
    func getProfile() async throws -> UserProfile
}

final class ProfileRepositoryImpl: ProfileRepository {
    private let tokenStorage: TokenStorage
    
    init(tokenStorage: TokenStorage) {
        self.tokenStorage = tokenStorage
    }
    
    func createProfile(firstName: String, lastName: String) async throws -> UserProfile {
        guard let token = tokenStorage.get("access_token") else {
            throw URLError(.userAuthenticationRequired)
        }
        
        guard let url = URL(string: "\(SupabaseConstants.projectURL)/rest/v1/users_profile") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(SupabaseConstants.anonKey, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("return=representation", forHTTPHeaderField: "Prefer")

        let body: [String: String] = [
            "first_name" : firstName,
            "last_name" : lastName ,
        ]
        
        request.httpBody = try JSONEncoder().encode(body)
        let(data,response) = try await URLSession.shared.data(for: request)
        let httpResponse = response as! HTTPURLResponse
        guard (200...299).contains(httpResponse.statusCode) else {
            print("Supabase error:", String(data: data, encoding: .utf8)!)
            throw AuthError.registrationFailed
        }
        
        return try JSONDecoder().decode(UserProfile.self, from: data)
    }
    
    func getProfile() async throws -> UserProfile {
        guard let token = tokenStorage.get("access_token") else {
            throw URLError(.userAuthenticationRequired)
        }
        
        guard let userId = tokenStorage.get("user_id") else {
                throw URLError(.userAuthenticationRequired)
            }
        
        guard let url = URL(string: "\(SupabaseConstants.projectURL)/rest/v1/users_profile?id=eq.\(userId)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(SupabaseConstants.anonKey, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let(data,response) = try await URLSession.shared.data(for: request)
        let httpResponse = response as! HTTPURLResponse
        guard (200...299).contains(httpResponse.statusCode) else {
            print("Supabase error:", String(data: data, encoding: .utf8)!)
            throw AuthError.registrationFailed
        }
        let profiles = try JSONDecoder().decode([UserProfile].self, from: data)
        guard let profile = profiles.first else {
            throw URLError(.cannotParseResponse)

        }
        return profile
    }
    
    
}
