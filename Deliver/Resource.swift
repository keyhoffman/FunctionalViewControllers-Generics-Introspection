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

struct Resource<A>: FirebaseObservable {
    let path: String
    let key: String
    let parse: (FBDictionary?, String, String) -> A?
    let resourceType: ResourceType
}









