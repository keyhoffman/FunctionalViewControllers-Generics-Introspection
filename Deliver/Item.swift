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
    let path: String
    let needsAutoId: Bool = false
    let name: String
    let additionalInformation: String
    let isCheckedOff: Bool
    
}

struct BodyThing: FireBaseSendable {
    let name: String
    let color: String
    let isYummy: Bool
    let key: String
    let path: String
    let needsAutoId: Bool = false
}

extension BodyThing {
    init?(data: FBDictionary?, itemID: String, path: String) {
        guard let data = data else { return nil }
        guard let name = data["name"] as? String, let color = data["color"] as? String, let yum = data["yummy"] as? Bool else { return nil }
        self.key = itemID
        self.name = name
        self.color = color
        self.isYummy = yum
        self.path = path
    }
}

extension Item {
    init?(data: FBDictionary?, key: String, path: String) {
        guard let data = data else { return nil }
        guard let itemMessage = data["itemMessage"] as? String, let name = data["name"] as? String,
            let addInfo = data["additionalInformation"] as? String, let checked = data["isCheckedOff"] as? Bool else { return nil }
        self.itemMessage = itemMessage
        self.name = name
        self.additionalInformation = addInfo
        self.isCheckedOff = checked
        self.key = key
        self.path = path
    }
    
    var bodyThings: Resource<BodyThing> {
        let btPath = "bodyThing/\(key)"
        let resource = Resource(path: btPath, key: "bodyThingKey", parse: BodyThing.init, resourceType: .BodyThing)
        return resource
    }
    
    static let resource = Resource(path: "items", key: "itemsKey", parse: Item.init, resourceType: .Item)
}
