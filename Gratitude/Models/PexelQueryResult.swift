//
//  PexelQueryResult.swift
//  Gratitude
//
//  Created by sukidhar on 02/10/22.
//

import Foundation

struct PexelQueryResult : Codable{
    let totalResults : Int
    let page: Int
    let perPage: Int
    let photos: [PexelPhoto]
    
    enum CodingKeys : String, CodingKey{
        case totalResults = "total_results"
        case page = "page"
        case perPage = "per_page"
        case photos = "photos"
    }
}

struct PexelPhoto : Codable{
    let src: PexelPhotoSource
}

struct PexelPhotoSource : Codable{
    let original : String
}
