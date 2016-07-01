//
//  User.swift
//  Deliver
//
//  Created by Key Hoffman on 6/30/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

struct User: FireBaseSendable {
    let key: String
    let path: String
    let name: String
    let email: String
    let needsAutoId: Bool = false
    
}

extension User {
    init?(data: FBDictionary?, key: String, path: String) {
        guard let data = data else { return nil }
        guard let name = data["name"] as? String, let email = data["email"] as? String else { return nil }
        self.name = name
        self.email = email
        self.key = key
        self.path = path
    }
    
    static let resource = Resource(path: "userPath", key: "userKey", parse: User.init, resourceType: .User)
    
    /// TODO: Find a better fix for this
    init() {
        self.name  = ""
        self.key   = ""
        self.path  = ""
        self.email = ""
    }
}
