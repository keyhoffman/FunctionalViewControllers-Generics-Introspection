//
//  Protocols.swift
//  Deliver
//
//  Created by Key Hoffman on 6/27/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation
import UIKit
import Firebase

protocol FirebaseType: Equatable {
    var path: String { get }
    var key: String { get }
}

protocol FireBaseSendable: FirebaseType {
    var path: String { get }
    var key: String { get }
    //    var needsAutoId: Bool { get }
}

protocol FirebaseObservable: FirebaseType {
    var path: String { get }
    var key: String { get }
    var FBKeys: [String] { get }
    
    associatedtype M
    var parse: (FBDictionary?, String, String) -> M? { get }
}

protocol LoadingType {
    associatedtype MyResourceType: FirebaseType
    var spinner: UIActivityIndicatorView? { get set }
    func configureMe(item: MyResourceType, _ action: LoadingAction)
}

enum LoadingAction {
    case Removed, Added
}

//TODO: Pass in .Removed or .Added at call site to remove repeated code
extension LoadingType where Self: UIViewController {
    func loadMe(r: Resource<MyResourceType>, withBlock: (MyResourceType?, LoadingAction) -> Void) {
        spinner?.startAnimating()
        r.RootRef.child(r.path).observeEventType(.ChildAdded) { (snapshot: FIRDataSnapshot) in
            withBlock(r.parse(snapshot.value as? FBDictionary, snapshot.key, r.path), .Added)
        }
        r.RootRef.child(r.path).observeEventType(.ChildRemoved) { (snapshot: FIRDataSnapshot) in
            withBlock(r.parse(snapshot.value as? FBDictionary, snapshot.key, r.path), .Removed)
        }
    }
}

protocol SendingType {
    associatedtype MyResourceType: FirebaseType
}

extension SendingType where Self: UIViewController {
    func sendMe(resource r: Resource<MyResourceType>, valueToSend val: String) {
        var fbDict: FBDictionary?
        switch r.resourceType {
        case .Item:      fbDict = val.convertToItemFBDictionary()
        case .BodyThing: print("BodyThing Type")
        }
        guard let dict = fbDict else { return }
        r.RootRef.child(r.path).childByAutoId().setValue(dict)
    }
    
    func removeMe(resource r: Resource<MyResourceType>, valueToRemove val: MyResourceType) {
        let path = r.path + "/" + val.key
        r.RootRef.child(path).removeValue()
    }
}
