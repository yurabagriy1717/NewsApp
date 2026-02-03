//
//  AppDIContainer.swift
//

import SwiftUI

@MainActor
final class AppDIContainer {
    static let shared = AppDIContainer()
    private init() {}
    
    private let networkService: NetworkService = NetworkServiceImp()
    private let newsBuilder: NewsBuildable = NewsBuilder()
    private let settingsService: SettingsServices = SettingsService()
    private let authService: AuthService = AuthServiceImp(sessionManager: SessionManagerImp(tokenStorage: TokenStorageImp()))
    private let tokenStorage: TokenStorage = TokenStorageImp()
    private let profileRepository: ProfileRepository = ProfileRepositoryImpl(tokenStorage: TokenStorageImp())
    private let savedArticlesService: SavedArticleService = SavedArticleServiceImpl(tokenStorage: TokenStorageImp() )
//    private let pushNotificationService: PushNotificationService = PushNofiticationServiceImpl()
    
    private lazy var sessionManager: SessionManager = SessionManagerImp(tokenStorage: tokenStorage)
    private lazy var themeViewModel = ThemeViewModel(settings : settingsService)
    
    @MainActor
    func makeNewsViewModel() -> NewsViewModel {
        return NewsViewModel(network: networkService,
                             newsModelBuilder: newsBuilder, savedArticlesService: savedArticlesService
        )
    }
    
    @MainActor
    func makeNewsDetailsViewModel(article: NewsModel) -> NewsDetailsViewModel {
        return NewsDetailsViewModel(article: article , savedArticlesService: savedArticlesService)
    }
    
    @MainActor
    func makeProfileViewModel() -> ProfileViewModel {
        return ProfileViewModel(settings: settingsService, sessionManager: sessionManager, profileRepository: profileRepository)
    }
    
    @MainActor
    func makeRegisterViewModel() -> RegisterViewModel {
        return RegisterViewModel(authService: authService, sessionManager: sessionManager, profileRepository: profileRepository)
    }
    
    @MainActor
    func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel(authService: authService, sessionManager: sessionManager)
    }
    
    @MainActor
    func makeFavouritesViewModel() -> FavouritesViewModel {
        return FavouritesViewModel(savedArticleService: savedArticlesService)
    }
    
    @MainActor
    func makeAppCoordinator() -> AppCoorinator {
        return AppCoorinator(session: sessionManager)
    }
    
    @MainActor
    func makeThemeViewModel() -> ThemeViewModel {
        themeViewModel
    }
}
