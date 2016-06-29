//
//  Utility.swift
//  Deliver
//
//  Created by Key Hoffman on 6/27/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation
import UIKit

enum Errors: ErrorType {
    case DictionaryWasNil(String)
}

extension BodyThing {
    init?(data: FBDictionary?, itemID: String, path: String) {
        guard let data = data else { return nil }
        guard let name = data["name"] as? String, let color = data["color"] as? String, let yum = data["yummy"] as? Bool else { return nil }
        self.key = itemID
        self.name = name
        self.color = color
        self.isYummy = yum
        self.path = path
    }
}

extension Item {
    init?(data: FBDictionary?, key: String, path: String) {
        guard let data = data else { return nil }
        guard let itemMessage = data["itemMessage"] as? String, let name = data["name"] as? String,
            let addInfo = data["additionalInformation"] as? String, let checked = data["isCheckedOff"] as? Bool else { return nil }
        self.itemMessage = itemMessage
        self.name = name
        self.additionalInformation = addInfo
        self.isCheckedOff = checked
        self.key = key
        self.path = path
    }
    
    var bodyThings: Resource<BodyThing> {
        let btPath = "bodyThing/\(key)"
        let resource = Resource(path: btPath, key: "bodyThingKey", parse: BodyThing.init, resourceType: .BodyThing)
        return resource
    }
    
    static let resource = Resource(path: "items", key: "itemsKey", parse: Item.init, resourceType: .Item)
}

extension User {
    init?(data: FBDictionary?, key: String, path: String) {
        guard let data = data else { return nil }
        guard let name = data["name"] as? String, let email = data["email"] as? String else { return nil }
        self.name = name
        self.email = email
        self.key = key
        self.path = path
    }
    
    static let resource = Resource(path: "userPath", key: "userKey", parse: User.init, resourceType: .User)
}

extension UITextField {
    func clearText() {
        self.text = ""
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
