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
    let path: String
    let needsAutoId: Bool
}