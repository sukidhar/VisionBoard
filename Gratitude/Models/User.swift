//
//  User.swift
//  Gratitude
//
//  Created by sukidhar on 30/09/22.
//

import Foundation
import RealmSwift

class UserObject : Object{
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var visionBoardTitle: String
    @Persisted var sections: List<SectionObject>
}


struct User : Identifiable{
    let id: ObjectId
    let name: String
    let visionBoardTitle: String
    let sections: [Section]
    
    init(id: ObjectId = .generate(), name: String, visionBoardTitle: String, sections: [Section]) {
        self.id = id
        self.name = name
        self.visionBoardTitle = visionBoardTitle
        self.sections = sections
    }
    
    init(_ userObject: UserObject) {
        self.id = userObject.id
        self.name = userObject.name
        self.visionBoardTitle = userObject.visionBoardTitle
        self.sections = userObject.sections.map({ .init($0) })
    }
    
    func getObject(){
        let object = UserObject()
        object.id = self.id
        object.name = self.name
        object.visionBoardTitle = self.visionBoardTitle
        object.sections = .init()
        self.sections.forEach {
            object.sections.append($0.getObject())
        }
    }
}
