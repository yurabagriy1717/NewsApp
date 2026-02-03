//
//  SettingsService.swift
//

import Foundation

protocol SettingsServices {
    func isDarkModeEnabled() -> Bool
    func isPushNotificationsEnabled() -> Bool
    
    func setDarkModel(_ value: Bool)
    func setPushNotifications(_ value: Bool)
    
    func resetSettings()
}


final class SettingsService: SettingsServices {
    private let userDefaults = UserDefaults.standard
    
    func isDarkModeEnabled() -> Bool {
        userDefaults.bool(forKey: "darkMode")
    }
    
    func isPushNotificationsEnabled() -> Bool {
        userDefaults.bool(forKey: "pushNotifications")
    }
    
    func setDarkModel(_ value: Bool) {
        userDefaults.set(value, forKey: "darkMode")
    }
    
    func setPushNotifications(_ value: Bool) {
        userDefaults.set(value, forKey: "pushNotifications")
    }
    
    func resetSettings() {
        userDefaults.removeObject(forKey: "darkMode")
        userDefaults.removeObject(forKey: "pushNotifications")
    }
    
}

    
    
