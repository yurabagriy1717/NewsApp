//
//  LanguageService.swift
//

import Foundation

protocol LanguageService {
    func currentLanguage() -> String
    func setLanguage(_ language: String)
}

final class LanguageServiceImpl: LanguageService {
    
    private let key = "language"
    private let userDefaults = UserDefaults.standard
    
    func currentLanguage() -> String {
        return "en"
    }
    
    func setLanguage(_ language: String) {
        userDefaults.set(language, forKey: key)
    }
}
