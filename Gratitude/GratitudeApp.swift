//
//  GratitudeApp.swift
//  Gratitude
//
//  Created by sukidhar on 30/09/22.
//

import SwiftUI

@main
struct GratitudeApp: App {
    @StateObject var stateManager : StateManager = .init()
    var body: some Scene {
        WindowGroup {
            switch stateManager.state{
            case .onboardingView:
                OnboardingView()
                    .environmentObject(stateManager)
            case .homeView:
                HomeView()
                    .environmentObject(stateManager)
            }
        }
    }
}
