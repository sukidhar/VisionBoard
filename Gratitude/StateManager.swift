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
    case homeView
}

class StateManager : ObservableObject{
    @Published private(set) var state = AppState.onboardingView
    
    var realm : Realm {
        return try! Realm(configuration: .init(deleteRealmIfMigrationNeeded: true))
    }
    
    func checkState(){
        if let _ = self.realm.objects(User.self).first{
            self.state = .homeView
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
