//
//  NewsDetailsViewModel.swift
//

import Foundation

final class NewsDetailsViewModel: ObservableObject {
    let article: NewsModel
    private let savedArticlesService: SavedArticleService
    
    init(
        article: NewsModel,
        savedArticlesService: SavedArticleService
    ) {
        self.article = article
        self.savedArticlesService = savedArticlesService
    }
    
    func savedArticles() async {
        do {
            let response = try await savedArticlesService.saved(article: article)
        } catch {
            print(error)
        }
    }
    
}
