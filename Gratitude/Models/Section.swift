//
//  Section.swift
//  Gratitude
//
//  Created by sukidhar on 01/10/22.
//

import RealmSwift

class Section : Object, ObjectKeyIdentifiable{
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var images: List<VBImage>
}

