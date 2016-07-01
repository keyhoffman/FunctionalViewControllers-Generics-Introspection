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
    let path: String
    let items: [Item]
    let sender: User
    let location: Location
    let status: Status
    let needsAutoId: Bool
    
    enum Status {
        case Accecpted, Active, Completed
    }
}
