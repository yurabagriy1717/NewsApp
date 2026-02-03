//
//  NewsResponse.swift
//

import Foundation

struct NewsResponse: Decodable {
    let status : String
    let totalResults: Int
    let articles: [ArticleApi]
}

struct ArticleApi: Decodable {
    let source: Source
    let author: String?
    let title: String
    let descprition: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}

struct Source: Decodable {
    let id: String?
    let name: String
}
