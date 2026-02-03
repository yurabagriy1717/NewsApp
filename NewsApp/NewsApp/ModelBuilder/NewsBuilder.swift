//
//  NewsBuilder.swift
//

import Foundation

protocol NewsBuildable {
    func mapNews(response: NewsResponse) -> [NewsModel]
}

class NewsBuilder: NewsBuildable {
    func mapNews(response: NewsResponse) -> [NewsModel] {
        response.articles.map { article in
            NewsModel(author: article.author,
                      title: article.title,
                      descprition: article.descprition,
                      url: article.url,
                      urlToImage: article.urlToImage,
                      publishedAt: article.publishedAt,
                      sourceName: article.source.name
            )
        }
    }
}
