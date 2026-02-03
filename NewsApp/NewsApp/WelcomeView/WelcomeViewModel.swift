//
//  WelcomeViewModel.swift
//

import Foundation

@MainActor
final class WelcomeViewModel: ObservableObject {
    var onContinue: (() -> Void)?
    
    func continueToApp() {
        onContinue?()
    }
}
