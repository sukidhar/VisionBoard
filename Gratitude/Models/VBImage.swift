//
//  VBImage.swift
//  Gratitude
//
//  Created by sukidhar on 01/10/22.
//

import RealmSwift

class VBImage : Object, ObjectKeyIdentifiable{
    @Persisted var link: String
    @Persisted var caption: String
}

