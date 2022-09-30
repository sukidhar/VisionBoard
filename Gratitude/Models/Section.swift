//
//  Section.swift
//  Gratitude
//
//  Created by sukidhar on 01/10/22.
//

import Foundation
import RealmSwift

class SectionObject : Object{
    @Persisted var title: String
    @Persisted var images: List<VBImageObject>
}

struct Section {
    let title: String
    let images : [VBImage]
    
    init(title: String, images: [VBImage]) {
        self.title = title
        self.images = images
    }
    
    init(_ sectionObject: SectionObject) {
        self.title = sectionObject.title
        self.images = sectionObject.images.map { .init($0) }
    }
    
    func getObject() -> SectionObject{
        let object = SectionObject()
        object.title = self.title
        object.images = .init()
        self.images.forEach {
            object.images.append($0.getObject())
        }
        return object
    }
}
