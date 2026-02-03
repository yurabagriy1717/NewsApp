//
//  FavouritesArticleResponse.swift
//

import Foundation

struct FavouritesArticleResponse: Decodable, Identifiable {
    let id: String
    let user_id: String
    let article_url: String
    let title: String
    let description: String?
    let image_url: String
}
