//
//  RootView.swift
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var coordinator: AppCoorinator
    @StateObject private var theme = AppDIContainer.shared.makeThemeViewModel()

    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            Group {
                switch coordinator.root {
                case .welcome:
                    WelcomeView(vm: WelcomeViewModel())
                case .login:
                    LoginView()
                case .register:
                    RegisterView()
                case .news:
                    MainTabView()
                default:
                    EmptyView()
                }
            }
            .environmentObject(theme)
            .preferredColorScheme(theme.isDarkMode ? .dark : .light)
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .detailsNews(let article):
                    NewsDetailsView(article: article)
                case.languageView:
                    LanguageView()
                case.aboutView:
                    AboutView()
                default:
                    EmptyView()
                }
            }
        }
    }
}
