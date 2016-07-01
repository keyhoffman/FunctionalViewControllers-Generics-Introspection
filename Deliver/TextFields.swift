//
//  TextFields.swift
//  Deliver
//
//  Created by Key Hoffman on 6/29/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation
import UIKit

class EmailTextField: UITextField {
    
    init<T: UIViewController where T: UITextFieldDelegate>(frame: CGRect, isFirstResponder i: Bool, delegate d: T) {
        super.init(frame: frame)
        self.tag = 0
        self.frame = frame
        if i { self.becomeFirstResponder() }
        self.delegate = d
        self.placeholder = "Enter your email"
        self.defaultSettings()
        self.keyboardType = .EmailAddress
        self.returnKeyType = .Next
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PasswordTextField: UITextField {
    
    init<T: UIViewController where T: UITextFieldDelegate>(frame: CGRect, delegate d: T) {
        super.init(frame: frame)
        self.tag = 1
        self.delegate = d 
        self.placeholder = "Enter your password"
        self.defaultSettings()
        self.secureTextEntry = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SearchTextField: UITextField {
    
    init<T: UIViewController where T: UITextFieldDelegate>(frame: CGRect, delegate d: T?, searchForPlaceholder s: String?) {
        super.init(frame: frame)
        self.frame = frame
        self.delegate = d
        if let s = s { self.placeholder = "Search for \(s)" }
        self.returnKeyType = .Search
        self.defaultSettings()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UITextField {
    func defaultSettings() {
        self.adjustsFontSizeToFitWidth = true
        self.autocapitalizationType = .None
        self.autocorrectionType = .No
        self.clearButtonMode = .Always
        self.keyboardAppearance = .Dark
        self.keyboardType = .Default
    }
}
