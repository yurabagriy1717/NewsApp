//
//  NewsModel.swift
//

import Foundation

struct NewsModel: Decodable , Identifiable, Hashable {
    var id: String { url }
    let author: String?
    let title: String
    let descprition: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let sourceName: String
}
