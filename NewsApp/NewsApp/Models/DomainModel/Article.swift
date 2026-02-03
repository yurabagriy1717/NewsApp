//
//  Article.swift
//

import Foundation

struct Article: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let source: String
    let imageURL: String
    let date: String
    let category: String
}
