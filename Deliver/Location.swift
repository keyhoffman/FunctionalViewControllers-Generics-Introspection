//
//  Location.swift
//  Deliver
//
//  Created by Key Hoffman on 6/30/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

struct Location: FireBaseSendable {
    let key: String
//    let path: String
//    let needsAutoId: Bool
}
extension Location {
    static let path = "locations/"
    static let needsAutoId = false
}

func == (lhs: Location, rhs: Location) -> Bool {
    return lhs.key == rhs.key
}