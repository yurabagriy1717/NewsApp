//
//  AuthResponse.swift
//

struct AuthResponse: Codable {
    let access_token: String
    let refresh_token: String?
    let token_type: String?
    let user: SupabaseUser?
}

struct SupabaseUser: Codable {
    let id: String
    let email: String?
}
