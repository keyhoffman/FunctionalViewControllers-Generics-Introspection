//
//  OpeningView.swift
//  Deliver
//
//  Created by Key Hoffman on 6/30/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation
import UIKit

class OpeningActionView: UIView {
    
    init<T: UIViewController where T: UITextFieldDelegate>(parentViewController vc: T) {
        let viewFrame = vc.view.frame
        super.init(frame: viewFrame)
        
        self.backgroundColor = .clearColor()
        
        let emailFrame = CGRect(x: 50, y: 150, width: 200, height: 21)
        let passwordFrame = CGRect(x: 50, y: 171, width: 200, height: 21)
        
        let emailTextField = EmailTextField(frame: emailFrame, isFirstResponder: true, delegate: vc)
        let passwordTextField = PasswordTextField(frame: passwordFrame, delegate: vc)
        passwordTextField.hidden = true
        
        self.addSubview(emailTextField)
        self.addSubview(passwordTextField)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
