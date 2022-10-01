//
//  GratitudeApp.swift
//  Gratitude
//
//  Created by sukidhar on 30/09/22.
//

import SwiftUI
import RealmSwift

@main
struct GratitudeApp: SwiftUI.App {
    @ObservedObject var stateManager = StateManager()
    
    init() {
        stateManager.checkState()
    }
    
    var body: some Scene {
        WindowGroup {
            let _ = print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path)
            switch stateManager.state{
            case .onboardingView:
                OnboardingView()
                    .environmentObject(stateManager)
            case .homeView(let user):
                HomeView(user: user)
                    .environmentObject(stateManager)
            }
        }
    }
}
