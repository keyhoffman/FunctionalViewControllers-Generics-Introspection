//
//  ViewTypes.swift
//  Deliver
//
//  Created by Key Hoffman on 6/30/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

protocol Configurable: class {
    associatedtype VC
    var configureSelf: VC -> Void { get }
}
