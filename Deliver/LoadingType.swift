//
//  LoadingType.swift
//  Deliver
//
//  Created by Key Hoffman on 6/30/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation
import Firebase

protocol LoadingDisplayType {
    associatedtype T: FireBaseSendable
    
    var spinner: UIActivityIndicatorView? { get }
    func configureMe(item: T, _ eventType: FIRDataEventType)
}

/// TODO: Pass in .Removed or .Added at call site to remove repeated code

extension LoadingDisplayType where Self: UIViewController {
    func loadMe(r: Resource<T>, withBlock: (T?, FIRDataEventType) -> Void) {
        spinner?.startAnimating()
        r.RootRef.child(T.path).observeEventType(.ChildAdded) { (snapshot: FIRDataSnapshot) in
            withBlock(r.parse(snapshot.value as? FBDictionary, snapshot.key), .ChildAdded)
        }
        r.RootRef.child(T.path).observeEventType(.ChildRemoved) { (snapshot: FIRDataSnapshot) in
            withBlock(r.parse(snapshot.value as? FBDictionary, snapshot.key), .ChildRemoved)
        }
    }
}
