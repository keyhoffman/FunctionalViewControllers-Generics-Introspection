//
//  Offers.swift
//  Deliver
//
//  Created by Key Hoffman on 6/30/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

struct Offer: FireBaseSendable {
    let key: String
//    let path: String
    let items: [Item]
    let sender: User
    let location: Location
    let status: Status
    
    enum Status {
        case Accecpted, Active, Completed
    }
}

extension Offer {
    static let path = "offers/"
    static let needsAutoId = false
}

func == (lhs: Offer, rhs: Offer) -> Bool {
    return lhs.key == rhs.key
}