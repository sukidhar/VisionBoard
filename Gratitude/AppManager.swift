//
//  AppManager.swift
//  Gratitude
//
//  Created by sukidhar on 01/10/22.
//

import RealmSwift
import Foundation

class AppManager {
    static func hasUser() -> Bool{
        guard let realm = try? Realm(configuration: .init(deleteRealmIfMigrationNeeded: true)) else {
            return false
        }
        return realm.objects(UserObject.self).count > 0
    }
}

