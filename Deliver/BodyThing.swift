//
//  BodyThing.swift
//  Deliver
//
//  Created by Key Hoffman on 7/1/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

struct BodyThing: FireBaseSendable {
    let name: String
    let color: String
    let isYummy: Bool
    let key: String
    //    let path: String
    //    let needsAutoId: Bool = false
}

extension BodyThing {
    init?(data: FBDictionary?, itemID: String) {
        guard let data = data else { return nil }
        guard let name = data["name"] as? String, let color = data["color"] as? String, let yum = data["yummy"] as? Bool else { return nil }
        self.key = itemID
        self.name = name
        self.color = color
        self.isYummy = yum
        //        self.path = path
    }
    
    static let needsAutoId: Bool = false
    static let path = "bodyThing/"
}

func == (lhs: BodyThing, rhs: BodyThing) -> Bool {
    return lhs.key == rhs.key
}
