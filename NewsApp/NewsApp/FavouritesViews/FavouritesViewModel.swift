//
//  FavouritesViewModel.swift
//

import Foundation

@MainActor
final class FavouritesViewModel: ObservableObject {
    @Published var articles: [FavouritesArticleResponse] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private let savedArticleService: SavedArticleService
    
    init(savedArticleService: SavedArticleService) {
        self.savedArticleService = savedArticleService
    }
    
    func loadArticles() async {
        isLoading = true
        do {
            articles = try await savedArticleService.getArticles()
            isLoading = false
        } catch {
            isLoading = false
            print("❌ Load favourites error:", error)
        }
    }
    
    func deleteArticle(_ article: FavouritesArticleResponse) async {
        do {
            try await savedArticleService.deleteArticle(id: article.id)
        } catch {
            print("error delete article: \(error)")
        }
    }
}
