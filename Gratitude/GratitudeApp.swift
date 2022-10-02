//
//  GratitudeApp.swift
//  Gratitude
//
//  Created by sukidhar on 30/09/22.
//

import SwiftUI
import RealmSwift
import Kingfisher

@main
struct GratitudeApp: SwiftUI.App {
    @ObservedObject var stateManager = StateManager()
    @ObservedResults(User.self) var users
    
    init() {
        ImageCache.default.diskStorage.config.sizeLimit = 1024 * 1024 * 500
        ImageCache.default.memoryStorage.config.totalCostLimit = 1024 * 1024 * 500
        stateManager.checkState()
    }
    
    var body: some Scene {
        WindowGroup {
            let _ = print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path)
            switch stateManager.state{
            case .onboardingView:
                OnboardingView()
                    .environmentObject(stateManager)
            case .homeView:
                HomeView(user: users.first!)
                    .environmentObject(stateManager)
            }
        }
    }
}
