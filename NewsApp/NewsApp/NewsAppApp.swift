//
//  NewsAppApp.swift
//

import SwiftUI

@main
struct NewsAppApp: App {
    @StateObject private var coordinator = AppDIContainer.shared.makeAppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(coordinator)
        }
    }
}
