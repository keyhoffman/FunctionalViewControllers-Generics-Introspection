//
//  MyTableViewController.swift
//  Deliver
//
//  Created by Key Hoffman on 6/25/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit
import Foundation
import Firebase

protocol FirebaseType {
    var path: String { get }
    var key: String { get }
}

protocol AdditionalInformationType {
    var additionalInformation: String { get set }
}

protocol AdditionalInformationConvertible: AdditionalInformationType {
    mutating func parseForAddInfo()
}

protocol FireBaseSendable: FirebaseType {
    var path: String { get }
    var key: String { get }
    var needsAutoId: Bool { get }
    
    associatedtype A
    var createNew: (String, String) -> A? { get }
}

//protocol CheckOffable: FirebaseType {
//    var isCheckedOff: Bool { get set }
//    mutating func checkOff(key: String, path: String)
//}

protocol FirebaseObservable: FirebaseType {
    var path: String { get }
    var key: String { get }
    var FBKeys: [String] { get }
    var eventType: FIRDataEventType { get }
    
    associatedtype A
    //associatedtype Resource
    var parse: (FBDictionary?, [String], String, String) -> A? { get }
}

struct Item: AdditionalInformationConvertible {
    let key: String
    let itemMessage: String
    let path: String
    var name: String
    var additionalInformation: String
    var isCheckedOff: Bool
    
    
    // TODO: MOVE THESE FUNCTIONS TO PROTOCOL EXTENSIONS
    mutating func parseForAddInfo() {
        let wordsArray = itemMessage.componentsSeparatedByString(" ")
        name = wordsArray[0]
        if wordsArray.count < 2 || wordsArray.count > 2 {
            additionalInformation = ""
        } else {
            additionalInformation = wordsArray[1][wordsArray[1].startIndex] == "#" ? wordsArray[1] :  ""
        }
    }
    
    mutating func checkOff(key: String, path: String) { isCheckedOff = !isCheckedOff }
}

struct BodyThing {
    let name: String
    let color: String
    let isYummy: Bool
    let itemID: String
    let path: String
}

extension BodyThing {
    init?(data: FBDictionary?, FBKeys: [String], itemID: String, path: String) {
        guard let data = data else { return nil }
        guard let name = data["name"] as? String, let color = data["color"] as? String, let yum = data["yummy"] as? Bool else { return nil }
        self.itemID = itemID
        self.name = name
        self.color = color
        self.isYummy = yum
        self.path = path
    }
}

extension Item {
    init?(data: FBDictionary?, FBKeys: [String], key: String, path: String) {
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
        let resource = Resource(path: btPath, key: "bodyThingKey", eventType: .ChildAdded, parse: BodyThing.init, needsAutoId: true, FBKeys: btKeys, resourceType: .BodyThing)
        return resource
    }
    
    static let resource = Resource(path: "items", key: "itemsKey", eventType: .ChildAdded, parse: Item.init, needsAutoId: true, FBKeys: itemKeys, resourceType: .Item)
}

typealias FBDictionary = [String:AnyObject]

struct Resource<A>: FirebaseObservable {
    let RootRef = FIRDatabase.database().reference()
    let path: String
    let key: String
    let eventType: FIRDataEventType
//    let parse: (Resource, [String:AnyObject], [String], String, String) -> A?
    let parse: (FBDictionary?, [String], String, String) -> A?
    let needsAutoId: Bool
    let FBKeys: [String]
    let resourceType: ResourceType
}

enum ResourceType {
    case Item
    case BodyThing
}

let fakeItemKeys: [String:Any.Type] = ["itemMessage" : String.self, "name" : String.self, "additionalInformation" : String.self, "isCheckedOff" : Bool.self]

let itemKeys = ["itemMessage", "name", "additionalInformation", "isCheckedOff"]

let btKeys = ["yummy", "color", "name"]

func loadResource<A>(resource: Resource<A>, withBlock: A? -> Void) {
    resource.RootRef.child(resource.path).observeEventType(resource.eventType) { (snapshot: FIRDataSnapshot) in
        withBlock(resource.parse(snapshot.value as? FBDictionary, resource.FBKeys, snapshot.key, resource.path))
    }
}


//func sendResource<A>(resource: Resource<A>, itemToSend item: String) {
//    print("sendResource = \(resource)")
////    if let newItem = resource.createNew(resource.path, item) {
////        if resource.needsAutoId {
//////            RootRef.child(newItem)
////        } else {
////
////        }
////    }
//
////    resource.parse(<#T##[String : AnyObject]#>, <#T##String#>, <#T##String#>)
//}

protocol LoadingType {
    associatedtype ResourceType
    var spinner: UIActivityIndicatorView { get }
    func configureMe(value: ResourceType)
}

//FIXME: BRAH -- watch objcio lecture 3
extension LoadingType where Self: UIViewController {
    func loadMe(resource: Resource<ResourceType>, withBlock: ResourceType? -> Void) {
        spinner.startAnimating()
        loadResource(resource) { [weak self] item in
            guard let item = item else { return } //TOD: display error
            self?.spinner.stopAnimating()
            self?.configureMe(item)
        }
    }
}


class MyTableViewController<T>: UITableViewController, UITextFieldDelegate, LoadingType {
    
    var items: [T] = []
    var didSelect: T -> () = { _ in }
    let resource: Resource<T>
    let configureCell: (UITableViewCell, T) -> ()
    let configureSelf: MyTableViewController -> ()
    var spinner: UIActivityIndicatorView?
    
    func configureMe(value: ResourceType) {
        
    }
    
    init(resource: Resource<T>, configureCell: (UITableViewCell, T) -> (), configureSelf: MyTableViewController -> ()) {
        self.resource = resource
        self.configureCell = configureCell
        self.configureSelf = configureSelf
        super.init(style: .Plain)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        configureSelf(self)
        loadMe(resource) { item in
            configureMe(item)
        }
        load()
    }
    
    private func load() {
        spinner?.startAnimating()
        loadResource(resource) { [weak self] item in
            guard let item = item else { return }
            self?.spinner?.stopAnimating()
            self?.items.append(item)
            self?.tableView.reloadData()
        }
    }

    // MARK: Textfield Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
//            if !text.isEmpty && text.wordsInString.count < 3 { print(text, text.wordsInString.count); sendResource(resource, itemToSend: text) }
        print(text)
        textField.clearText()
        return true
    }
    
    func send(textField: UITextField) {
        print("SEND")
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: nil)
        let item = items[indexPath.row]
        configureCell(cell, item)

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = items[indexPath.row]
        didSelect(item)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */
    

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
