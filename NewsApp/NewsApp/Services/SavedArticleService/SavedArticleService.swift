//
//  SavedArticleService.swift
//

import Foundation

protocol SavedArticleService {
    func saved(article: NewsModel) async throws -> FavouritesArticleResponse
    func deleteArticle(id: String) async throws
    func getArticles() async throws -> [FavouritesArticleResponse]
    
}

final class SavedArticleServiceImpl: SavedArticleService {
    private let tokenStorage: TokenStorage

    init(tokenStorage: TokenStorage) {
        self.tokenStorage = tokenStorage
    }
    
    func saved(article: NewsModel) async throws -> FavouritesArticleResponse {
        guard let token = tokenStorage.get("access_token") else {
            throw URLError(.userAuthenticationRequired)
        }
        
        guard let userId = tokenStorage.get("user_id") else {
            throw URLError(.userAuthenticationRequired)
        }
        
        guard let url = URL(string: "\(SupabaseConstants.projectURL)/rest/v1/favourites_articles") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(SupabaseConstants.anonKey, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("return=representation", forHTTPHeaderField: "Prefer")
        
        let body = [
            "user_id" : userId,
            "article_url" : article.id,
            "title" : article.title,
            "description" : article.descprition,
            "image_url" : article.urlToImage
        ]
        
        request.httpBody = try JSONEncoder().encode(body)
        let(data,response) = try await URLSession.shared.data(for: request)
        
        let httpResponse = response as! HTTPURLResponse
        guard (200...299).contains(httpResponse.statusCode) else {
            print("Supabase error:", String(data: data, encoding: .utf8)!)
            throw AuthError.registrationFailed
        }
        let articles = try JSONDecoder().decode([FavouritesArticleResponse].self, from: data)
        
        guard let article = articles.first else {
            throw URLError(.cannotParseResponse)
        }
        
        return article
    }
    
    func deleteArticle(id: String) async throws {
        guard let token = tokenStorage.get("access_token") else {
            throw URLError(.userAuthenticationRequired)
        }
        guard let userId = tokenStorage.get("user_id") else {
            throw URLError(.userAuthenticationRequired)
        }
        guard let url = URL(string: "\(SupabaseConstants.projectURL)/rest/v1/favourites_articles/\(id)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue(SupabaseConstants.anonKey, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let(data,response) = try await URLSession.shared.data(for: request)
        let httpResponse = response as! HTTPURLResponse
        guard (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }
        
    }
    
    func getArticles() async throws -> [FavouritesArticleResponse] {
        guard let token = tokenStorage.get("access_token") else {
            throw URLError(.userAuthenticationRequired)
        }
        guard let userId = tokenStorage.get("user_id") else {
            throw URLError(.userAuthenticationRequired)
        }
        guard let url = URL(string: "\(SupabaseConstants.projectURL)/rest/v1/favourites_articles?user_id=eq.\(userId)") else {
            throw URLError(.badURL)
        }
        
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(SupabaseConstants.anonKey, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let(data,response) = try await URLSession.shared.data(for: request)
        let httpResponse = response as! HTTPURLResponse
        guard (200...299).contains(httpResponse.statusCode) else {
            print("Supabase error:", String(data: data, encoding: .utf8)!)
            throw AuthError.registrationFailed
        }
        
        print("🔑 token user_id:", userId)
        print("🧾 JWT access_token:", token)
        print("🌍 URL:", url.absoluteString)
        print("📦 RAW RESPONSE:", String(data: data, encoding: .utf8) ?? "nil")
        
        return try JSONDecoder().decode([FavouritesArticleResponse].self, from: data)
    }
}
