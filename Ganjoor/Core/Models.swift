//
//  Models.swift
//  Ganjoor
//
//  Created by Farzad Nazifi on 5/5/17.
//  Copyright © 2017 boon. All rights reserved.
//

import Foundation
import Moya_SwiftyJSONMapper
import SwiftyJSON

struct Category: ALSwiftyJSONAble {
    let id: Int
    let poetid: Int
    let name: String
    let parentid: Int?
    let hierarchyLevel: Int?
    let url: String
    
    init?(jsonData: JSON) {
        id = jsonData["id"].intValue
        poetid = jsonData["poetid"].intValue
        name = jsonData["name"].stringValue
        parentid = jsonData["parentid"].int
        hierarchyLevel = jsonData["hierarchyLevel"].int
        url = jsonData["url"].stringValue
    }
}

struct Poet: ALSwiftyJSONAble {
    let id: Int
    let categoryId: Int
    let name: String
    let description: String?
    
    init?(jsonData: JSON) {
        id = jsonData["id"].intValue
        categoryId = jsonData["categoryId"].intValue
        name = jsonData["name"].stringValue
        description = jsonData["description"].string
    }
}

struct Poem: ALSwiftyJSONAble {
    let id: Int
    let categoryId: Int
    let title: String
    let url: String?
    
    init?(jsonData: JSON) {
        id = jsonData["id"].intValue
        categoryId = jsonData["categoryId"].intValue
        title = jsonData["title"].stringValue
        url = jsonData["url"].string
    }
}

struct Verse: ALSwiftyJSONAble {
    let id: Int
    let poemId: Int?
    let order: Int?
    let position: Int
    let text: String
    
    init?(jsonData: JSON) {
        id = jsonData["id"].intValue
        poemId = jsonData["poemId"].int
        order = jsonData["order"].int
        position = jsonData["position"].intValue
        text = jsonData["text"].stringValue
    }
}
