//
//  ThemeViewModel.swift
//

import SwiftUI

final class ThemeViewModel: ObservableObject {
    @Published var isDarkMode: Bool {
        didSet {
            settings.setDarkModel(isDarkMode)
        }
    }
    
    private let settings: SettingsServices
    
    init(settings: SettingsServices) {
        self.isDarkMode = settings.isDarkModeEnabled()
        self.settings = settings
    }
}


