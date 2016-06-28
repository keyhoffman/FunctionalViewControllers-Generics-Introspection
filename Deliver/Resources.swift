//
//  Resources.swift
//  Deliver
//
//  Created by Key Hoffman on 6/27/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation
import Firebase

typealias FBDictionary = [String : AnyObject]

enum ResourceType {
    case Item, BodyThing, Offer, User, Location
}

struct Resource<A>: FirebaseObservable, FireBaseSendable {
    let RootRef = FIRDatabase.database().reference()
    let path: String
    let key: String
    let parse: (FBDictionary?, String, String) -> A?
    let resourceType: ResourceType
}

struct Offer: FirebaseType {
    let key: String
    let path: String
    let items: [Item]
    let sender: User
    let location: Location
    let status: Status
    
    enum Status {
        case Accecpted, Active, Completed
    }
}

struct Location: FirebaseType {
    let key: String
    let path: String
}

struct User: FirebaseType {
    let key: String
    let path: String
    let name: String
    let email: String
    
}

struct Item: FirebaseType {
    let key: String
    let itemMessage: String
    let path: String
    var name: String
    var additionalInformation: String
    var isCheckedOff: Bool
}

struct BodyThing: FirebaseType {
    let name: String
    let color: String
    let isYummy: Bool
    let key: String
    let path: String
}




