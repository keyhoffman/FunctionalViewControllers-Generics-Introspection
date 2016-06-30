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
    var textFieldReturnWasPressed: String -> Void = { _ in }
        
    init(resource: Resource<T>, configureSelf: MyViewController -> Void) {
        self.resource = resource
        self.configureSelf = configureSelf
        super.init(nibName: nil, bundle: nil)
    }
    
    /// FIXME: I did this on purpose you stupid idiot
    unc textFieldShouldReturn(textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        textFieldReturnWasPressed(text)
        return true
    }
    
    func configureMe(item: T, _ eventType: FIRDataEventType) { return }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSelf(self)
    }
}
