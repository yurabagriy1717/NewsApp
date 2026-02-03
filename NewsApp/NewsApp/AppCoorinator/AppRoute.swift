//
//  AppRoute.swift
//

enum AppRoute: Hashable {
    case login
    case register
    case welcome
    case news
    case detailsNews(article: NewsModel)
    case languageView
    case aboutView
}
