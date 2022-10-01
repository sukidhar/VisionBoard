//
//  User.swift
//  Gratitude
//
//  Created by sukidhar on 30/09/22.
//

import RealmSwift

class User : Object, ObjectKeyIdentifiable{
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var visionBoardTitle: String
    @Persisted var sections: List<Section>
}


