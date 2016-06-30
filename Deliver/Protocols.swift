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
    
    associatedtype M
    var parse: (FBDictionary?, String, String) -> M? { get }
}

protocol LoadingDisplayType {
    associatedtype MyResourceType: FirebaseType
    
    var spinner: UIActivityIndicatorView? { get }
    func configureMe(item: MyResourceType, _ eventType: FIRDataEventType)
}

///TODO: Pass in .Removed or .Added at call site to remove repeated code
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

protocol Configurable: class {
    associatedtype VC
    var configureSelf: VC -> Void { get }
}

protocol SendingDisplayType: UITextFieldDelegate {
    associatedtype MyResourceType: FirebaseType
    var textFieldReturnWasPressed: String -> Void { get }
}

extension SendingDisplayType where Self: UIViewController {
    func sendMe(resource r: Resource<MyResourceType>, valueToSend val: String) {
        var fbDict: FBDictionary?
        switch r.resourceType {
        case .Item:      fbDict = val.convertToItemFBDictionary() /// TODO: Check to make sure this works without the prior checks
        case .BodyThing: print("BodyThing")
        case .Offer:     print("Offer")
        case .User:      print("User")
        case .Location:  print("Location")
        }
        guard let dict = fbDict else { return }
        r.RootRef.child(r.path).childByAutoId().setValue(dict)
    }
    
//    func textFieldShouldReturn(textField t: UITextField, num n: Int) -> Bool {
//        guard let text = t.text else { return true }
//        print("text = \(text, n)")
//        t.clearText()
//        return true
//    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        print("textFieldDidBeginEditing")
    }
    
    func textFieldShouldReturn(textfield t: UITextField, resource r: Resource<MyResourceType>) -> Bool {
        print("textFieldShouldReturn")
        dump(r)
        guard let text = t.text else { return true }
        if !text.isEmpty {
            dump(text)
            dump(r)
//            sendMe(resource: r, valueToSend: text)
            t.clearText()
        }
        return true
    }
    
    func removeMe(resource r: Resource<MyResourceType>, valueToRemove val: MyResourceType) {
        let path = r.path + "/" + val.key
        r.RootRef.child(path).removeValue()
    }
}



