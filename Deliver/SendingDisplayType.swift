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
    associatedtype MyResourceType: FirebaseType
    func textFieldShouldReturn(textField: UITextField) -> Bool
    var textFieldReturnWasPressed: (UITextField) throws -> Void { get }
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
    
    func removeMe(resource r: Resource<MyResourceType>, valueToRemove val: MyResourceType) {
        let path = r.path + "/" + val.key
        r.RootRef.child(path).removeValue()
    }
}
