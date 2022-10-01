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
        DispatchQueue.main.async { [unowned self] in
            if let user = realm.objects(User.self).first{
                self.state = .homeView(user: user)
            }else{
                self.state = .onboardingView
            }
        }
    }
    
    func set(state: AppState){
        self.state = state
    }
    
    func set(user: User){
        try? realm.write({
            realm.add(user)
        })
        DispatchQueue.main.async { [unowned self] in
            self.set(state: .homeView(user: user))
        }
    }
}
