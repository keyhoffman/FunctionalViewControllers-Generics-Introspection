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
    associatedtype MyResourceType: FirebaseType
    
    var spinner: UIActivityIndicatorView? { get }
    func configureMe(item: MyResourceType, _ eventType: FIRDataEventType)
}

/// TODO: Pass in .Removed or .Added at call site to remove repeated code

extension LoadingDisplayType where Self: UIViewController {
    func loadMe(r: Resource<MyResourceType>, withBlock: (MyResourceType?, FIRDataEventType) -> Void) {
        spinner?.startAnimating()
        r.RootRef.child(r.path).observeEventType(.ChildAdded) { (snapshot: FIRDataSnapshot) in
            withBlock(r.parse(snapshot.value as? FBDictionary, snapshot.key, r.path), .ChildAdded)
        }
        r.RootRef.child(r.path).observeEventType(.ChildRemoved) { (snapshot: FIRDataSnapshot) in
            withBlock(r.parse(snapshot.value as? FBDictionary, snapshot.key, r.path), .ChildRemoved)
        }
    }
}
