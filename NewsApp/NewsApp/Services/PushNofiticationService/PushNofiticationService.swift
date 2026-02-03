//
//  PushNofiticationService.swift
//

import UserNotifications
import Foundation

protocol PushNotificationService {
    func requestPush() async -> Bool
    func scheduleDailyNotification(hour: Int, minute: Int, title: String, body: String)
    func removeDailyNotification()
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async
}

final class PushNofiticationServiceImpl: NSObject, UNUserNotificationCenterDelegate, PushNotificationService {
    
    private let pushNotificationService: PushNotificationService
    
    init(pushNotificationService: PushNotificationService) {
        self.pushNotificationService = pushNotificationService
    }
    
    func requestPush() async -> Bool {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            return granted
        } catch {
            print("Permission error:", error)
            return false
        }
    }
    
    func scheduleDailyNotification(hour: Int, minute: Int, title: String, body: String) {
        var date = DateComponents()
        date.hour = hour
        date.minute = minute
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(identifier: "daily-remaing"
                                            , content: content,
                                            trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func removeDailyNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["daily-remaing"])
    }
    
    func userNotificationCenter(
            _ center: UNUserNotificationCenter,
            didReceive response: UNNotificationResponse
        ) async {

            print("User tapped daily reminder")
        }
    
}
