//
//  MyViewController.swift
//  Deliver
//
//  Created by Key Hoffman on 6/28/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit
import Firebase

//protocol Completeable {
//    associatedtype completedObjective
//}
//
//extension Completeable {
//    func didComplete(completedObjective)
//}

///FIXME: SendingDisplayType conformence error
class MyViewController<T: FirebaseType>: UIViewController, UITextFieldDelegate, Configurable, LoadingDisplayType, SendingDisplayType {
    
    let resource: Resource<T>
    let configureSelf: MyViewController -> Void
    var didCompleteViewContollerObjective: T -> Void = { _ in }
    var spinner: UIActivityIndicatorView?
        
    init(resource: Resource<T>, configureSelf: MyViewController -> Void) {
        self.resource = resource
        self.configureSelf = configureSelf
        super.init(nibName: nil, bundle: nil)
    }
    
    func configureMe(item: T, _ eventType: FIRDataEventType) {
        print("A")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSelf(self)
    }
}
