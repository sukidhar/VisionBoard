//
//  VBImage.swift
//  Gratitude
//
//  Created by sukidhar on 01/10/22.
//

import Foundation
import RealmSwift

class VBImageObject : Object{
    @Persisted var link: String
    @Persisted var caption: String
}

struct VBImage {
    let link: String
    let caption: String
    
    init(link: String, caption: String) {
        self.link = link
        self.caption = caption
    }
    
    init(_ vbImageObject : VBImageObject) {
        self.link = vbImageObject.link
        self.caption = vbImageObject.caption
    }
    
    func getObject() -> VBImageObject{
        let object = VBImageObject(
            value: [
                "link" : self.link,
                "caption" : self.caption
            ]
        )
        return object
    }
}
