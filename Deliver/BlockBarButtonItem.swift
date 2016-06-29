//
//  BlockBarButtonItem.swift
//  Deliver
//
//  Created by Key Hoffman on 6/29/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation
import UIKit

class BlockBarButtonItem : UIBarButtonItem {
    
    private var actionHandler: ((Void) -> Void)?
    
    convenience init(title: String?, style: UIBarButtonItemStyle, actionHandler: ((Void) -> Void)?) {
        self.init(title: title, style: style, target: nil, action: nil)
        self.target = self
        self.action = #selector(BlockBarButtonItem.barButtonItemPressed(_:))
        self.actionHandler = actionHandler
    }
    
    func barButtonItemPressed(sender: UIBarButtonItem) {
        if let actionHandler = self.actionHandler {
            actionHandler()
        }
    }
    
}