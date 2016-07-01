//
//  FBTypes.swift
//  Deliver
//
//  Created by Key Hoffman on 6/30/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation
import UIKit
import Firebase

protocol FirebaseType: Equatable {
    var path: String { get }
    var key: String  { get }
}

extension FirebaseType {
    var RootRef: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
}

protocol FireBaseSendable: FirebaseType {
    var path: String      { get }
    var key: String       { get }
    var needsAutoId: Bool { get }
}

extension FireBaseSendable {
    func sendToFB() {
        guard let FBDict = convertToFBSendable() else { return }
        print("-- FBDump --")
        dump(FBDict)
        if needsAutoId { self.RootRef.child(path).childByAutoId().setValue(FBDict) }
        else {
            let p = path + "/" + key
            self.RootRef.child(p).setValue(FBDict)
        }
    }
    
    func convertToFBSendable() -> FBDictionary? {
        var FBDict: FBDictionary = [:]
        let mirror = Mirror(reflecting: self)
        for case let (label?, value) in mirror.children {
            print("label = \(label), value = \(value)")
            FBDict[label] = value as? AnyObject
        }
        return Dictionary(FBDict.filter { $0.0 == "name" || $0.0 == "email" })
    }
}

extension Dictionary {
    init(_ pairs: [Element]) {
        self.init()
        for (k, v) in pairs {
            self[k] = v
        }
    }
}


protocol FirebaseObservable: FirebaseType {
    var path: String { get }
    var key: String  { get }
    
    associatedtype M
    var parse: (FBDictionary?, String, String) -> M? { get }
}

enum OpeningAction: String {
    case Login  = "Login"
    case SignUp = "Sign Up"
}

protocol FBAuthable {
    static var authEmail: String       { get set }
    static var authPassword: String    { get set }
}

extension FBAuthable {
    // TODO: Figure out a way to avoid code duplication
    func authorizeUser(authorizeAction action: OpeningAction, withBlock: (firUser: FIRUser?, error: NSError?) -> Void) {
        switch action {
        case .SignUp:
            FIRAuth.auth()?.createUserWithEmail(Self.authEmail, password: Self.authPassword) { user, error in
                withBlock(firUser: user, error: error)
            }
        case .Login:
            FIRAuth.auth()?.signInWithEmail(Self.authEmail, password: Self.authPassword) { user, error in
                withBlock(firUser: user, error: error)
            }
        }
    }
}

extension User: FBAuthable {    
    static var authPassword: String = ""
    static var authEmail: String    = ""
}























