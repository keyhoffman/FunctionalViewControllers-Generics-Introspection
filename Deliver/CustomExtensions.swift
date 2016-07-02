//
//  Utility.swift
//  Deliver
//
//  Created by Key Hoffman on 6/27/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func clearText() {
        self.text = ""
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

extension UIActivityIndicatorView {
    func addToSuperView(parentVC: UIViewController) {
        self.hidesWhenStopped = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.center = parentVC.view.center
        parentVC.view.addSubview(self)
    }
}

extension String {
    var wordsInString: [String] {
        var result: [String] = []
        enumerateSubstringsInRange(characters.indices, options: .ByWords) { result.append($0.substring!) }
        return result
    }
    
    func convertToItemFBDictionary() -> FBDictionary {
        let wordsArray = self.componentsSeparatedByString(" ")
        var fbDict: FBDictionary = [:]
        
        fbDict["name"]                  = wordsArray[0]
        fbDict["additionalInformation"] = wordsArray.count < 2 || wordsArray.count > 2 ? "" : wordsArray[1][wordsArray[1].startIndex] == "#" ? wordsArray[1] : ""
        fbDict["itemMessage"]           = self
        fbDict["isCheckedOff"]          = false
        
        return fbDict
    }
}
