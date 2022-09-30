//
//  GratitudeApp.swift
//  Gratitude
//
//  Created by sukidhar on 30/09/22.
//

import SwiftUI

@main
struct GratitudeApp: App {
    var body: some Scene {
        WindowGroup {
            if AppManager.hasUser(){
                HomeView(title: "")
            }else{
                OnboardingOpeningView()
            }
        }
    }
}
