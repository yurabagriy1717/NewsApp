//
//  NetworkService.swift
//

import Foundation
import Combine

protocol NetworkService {
    func fetchNews(for query: String) async throws -> NewsResponse
    func fetchNewsCategory(for category: String) async throws -> NewsResponse
//    var publisher: AnyPublisher<Any, Error> { get }
}

final class NetworkServiceImp: NetworkService {
//    private let subject = PassthroughSubject<Any, Error>()
//    
//    var publisher: AnyPublisher<Any, Error> {
//        subject.eraseToAnyPublisher()
//    }
    let apiKey = "d8526455aee54e6089464fecf38aa731"
    
    func fetchNews(for query: String/*, responseData: @escaping (NewsResponse) -> Voi*/) async throws -> NewsResponse {
//        subject.send()
//        subject.sink(receiveCompletion: , receiveValue: )
//        
//        
//        subject.send(NewsResponse(status: "", totalResults: 33, articles: []))
//        
        let endpoint: String
        
        if query.isEmpty {
            endpoint = "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(apiKey)"
        } else {
            let q = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
            endpoint = "https://newsapi.org/v2/everything?q=\(q)&apiKey=\(apiKey)"
        }
        
        guard let url = URL(string: endpoint)
        else {
            throw URLError(.badURL)
        }
        
        do {
            let(data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...300).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }
//            let parsedData = try JSONDecoder().decode(NewsResponse.self, from: data)
//            responseData(parsedData)
            return try JSONDecoder().decode(NewsResponse.self, from: data)
        } catch {
            print("❌ Network error:", error)
            throw error
        }
    }
    
    func fetchNewsCategory(for category: String) async throws -> NewsResponse {
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?category=\(category)&apiKey=\(apiKey)")
        else {
            throw URLError(.badURL)
        }
        
        do {
            let(data,response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...300).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }
            return try JSONDecoder().decode(NewsResponse.self, from: data)
        }
    }
    
}
