//
//  Resources.swift
//  Deliver
//
//  Created by Key Hoffman on 6/27/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation
import Firebase

//TODO: change all path vars to static vars

typealias FBDictionary = [String : AnyObject]

enum ResourceType {
    case Item, BodyThing, Offer, User, Location
}

struct Resource<A: FireBaseSendable>: FirebaseObservable {
//    var key: String { return A.key }
    let parse: (FBDictionary?, String) -> A?
    let resourceType: ResourceType
    static var path: String      { return A.path + "/" }
    static var needsAutoId: Bool { return A.needsAutoId }
}










