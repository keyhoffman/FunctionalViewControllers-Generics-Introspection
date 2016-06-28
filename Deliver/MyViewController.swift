//
//  MyViewController.swift
//  Deliver
//
//  Created by Key Hoffman on 6/28/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

//protocol Completeable {
//    associatedtype completedObjective
//}
//
//extension Completeable {
//    func didComplete(completedObjective)
//}

class MyViewController<T: FirebaseType>: UIViewController, Configurable, UITextFieldDelegate {
    
    private let resource: Resource<T>
    let configureSelf: MyViewController -> Void
    var didCompleteViewContollerObjective: T -> Void = { _ in }
    
    init(resource: Resource<T>, configureSelf: MyViewController -> Void) {
        self.resource = resource
        self.configureSelf = configureSelf
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSelf(self)
    }
}
