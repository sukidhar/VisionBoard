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
    
    func checkState(){
        guard let realm = try? Realm(configuration: .init(deleteRealmIfMigrationNeeded: true)) else {
            return
        }
        try? realm.write({
            realm.deleteAll()
        })
        if let _ = realm.objects(User.self).first{
            state = .homeView
        }else{
            state = .onboardingView
        }
    }
    
    func set(state: AppState){
        self.state = state
    }
    
    func set(user: User){
        guard let realm = try? Realm(configuration: .init(deleteRealmIfMigrationNeeded: true)) else {
            return
        }
        try? realm.write({
            realm.add(user)
        })
    }
}
