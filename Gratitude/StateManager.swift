//
//  StateManager.swift
//  Gratitude
//
//  Created by sukidhar on 01/10/22.
//

import Foundation
import RealmSwift

enum AppState{
    case onboardingView
    case homeView(user: User)
}

class StateManager : ObservableObject{
    @Published private(set) var state = AppState.onboardingView
    
    var realm : Realm {
        return try! Realm(configuration: .init(deleteRealmIfMigrationNeeded: true))
    }
    
    func checkState(){
        if let user = self.realm.objects(User.self).first{
            self.state = .homeView(user: user)
        }else{
            self.state = .onboardingView
        }
    }
    
    func set(state: AppState){
        DispatchQueue.main.async { [weak self] in
            self?.state = state
        }
    }
}
