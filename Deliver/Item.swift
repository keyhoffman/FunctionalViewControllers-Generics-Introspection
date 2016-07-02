//
//  Item.swift
//  Deliver
//
//  Created by Key Hoffman on 6/30/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

struct Item: FireBaseSendable {
    let key: String
    let itemMessage: String
//    let path: String
//    let needsAutoId: Bool = false
    let name: String
    let additionalInformation: String
    let isCheckedOff: Bool
    
}

extension Item {
    init?(data: FBDictionary?, key: String) {
        guard let data = data else { return nil }
        guard let itemMessage = data["itemMessage"] as? String, let name = data["name"] as? String,
            let addInfo = data["additionalInformation"] as? String, let checked = data["isCheckedOff"] as? Bool else { return nil }
        self.itemMessage = itemMessage
        self.name = name
        self.additionalInformation = addInfo
        self.isCheckedOff = checked
        self.key = key
//        self.path = path
    }
    
    var bodyThings: Resource<BodyThing> {
        let btPath = BodyThing.path + "/" + key
        let resource = Resource(parse: BodyThing.init, resourceType: .BodyThing)
        return resource
    }
    
    static let needsAutoId: Bool = false
    static let path = "items/"
    
//    static let resource = Resource(path: Item.path, key: "itemsKey", parse: Item.init, resourceType: .Item)
    static let resource = Resource(parse: Item.init, resourceType: .Item)
}

func == (lhs: Item, rhs: Item) -> Bool {
    return lhs.key == rhs.key
}



