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
class MyViewController<T: FireBaseSendable>: UIViewController, UITextFieldDelegate, Configurable, LoadingDisplayType, SendingDisplayType {
    
    let resource: Resource<T>
    let configureSelf: MyViewController -> Void
    var textFieldReturnWasPressed: (UITextField) throws -> Void = { _ in }
    var spinner: UIActivityIndicatorView?
    var textInputDict: [String:String] = [:]
        
    init(resource: Resource<T>, configureSelf: MyViewController -> Void) {
        self.resource = resource
        self.configureSelf = configureSelf
        super.init(nibName: nil, bundle: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        do {
            try textFieldReturnWasPressed(textField)
        } catch {
            print(error)
        }
        return true
    }
    
    func configureMe(item: T, _ eventType: FIRDataEventType) { return }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSelf(self)
    }
}
