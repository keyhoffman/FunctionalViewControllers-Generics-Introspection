//
//  Sending.swift
//  Deliver
//
//  Created by Key Hoffman on 6/30/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation
import Firebase

protocol SendingDisplayType: UITextFieldDelegate {
    associatedtype T: FireBaseSendable
    func textFieldShouldReturn(textField: UITextField) -> Bool
    var textFieldReturnWasPressed: (UITextField) throws -> Void { get }
}

extension SendingDisplayType where Self: UIViewController {
    func sendMe(resource r: Resource<T>, valueToSend val: String) {
        var fbDict: FBDictionary?
        switch r.resourceType {
        case .Item:      fbDict = val.convertToItemFBDictionary() /// TODO: Check to make sure this works without the prior checks
        case .BodyThing: print("BodyThing")
        case .Offer:     print("Offer")
        case .User:      print("User")
        case .Location:  print("Location")
        }
        guard let dict = fbDict else { return }
//        r.RootRef.child(r.path).childByAutoId().setValue(dict)
        print("SendingDisplayType generic path = \(T.path)")
        if T.needsAutoId { r.RootRef.child(T.path).childByAutoId().setValue(dict) }
        else {
            fatalError("FIXME!")
        }
    }
    
    func removeMe(resource r: Resource<T>, valueToRemove val: T) {
        let path = T.path + "/" + val.key
        r.RootRef.child(path).removeValue()
    }
}
