//
//  OverLoaders.swift
//  Deliver
//
//  Created by Key Hoffman on 6/27/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

func ==<A>(lhs: Resource<A>, rhs: Resource<A>) -> Bool {
    return lhs.key == rhs.key
}

func == (lhs: Item, rhs: Item) -> Bool {
    return lhs.key == rhs.key
}


func == (lhs: BodyThing, rhs: BodyThing) -> Bool {
    return lhs.key == rhs.key
}
