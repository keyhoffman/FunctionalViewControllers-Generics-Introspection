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


protocol FireBaseSendable: FirebaseType {
    var path: String { get }
    var key: String { get }
    var needsAutoId: Bool { get }
}

//protocol CheckOffable: FirebaseType {
//    var isCheckedOff: Bool { get set }
//    mutating func checkOff(key: String, path: String)
//}

protocol FirebaseObservable: FirebaseType {
    var path: String { get }
    var key: String { get }
    var FBKeys: [String] { get }
    
    associatedtype M
    var parse: (FBDictionary?, String, String) -> M? { get }
}

struct Item {
    let key: String
    let itemMessage: String
    let path: String
    var name: String
    var additionalInformation: String
    var isCheckedOff: Bool
    
    
    // TODO: MOVE THESE FUNCTIONS TO PROTOCOL EXTENSIONS
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
    init?(data: FBDictionary?, itemID: String, path: String) {
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
    
    static let itemKeys = ["itemMessage", "name", "additionalInformation", "isCheckedOff"]
    
    static let btKeys = ["yummy", "color", "name"]
    
    var bodyThings: Resource<BodyThing> {
        let btPath = "bodyThing/\(key)"
        let resource = Resource(path: btPath, key: "bodyThingKey", parse: BodyThing.init, resourceType: .BodyThing, FBKeys: Item.btKeys)
        return resource
    }
    
    static let resource = Resource(path: "items", key: "itemsKey", parse: Item.init, resourceType: .Item, FBKeys: Item.itemKeys)
}

typealias FBDictionary = [String:AnyObject]

struct Resource<A>: FirebaseObservable {
    let RootRef = FIRDatabase.database().reference()
    let path: String
    let key: String
    let parse: (FBDictionary?, String, String) -> A?
    let resourceType: ResourceType
//    let needsAutoId: Bool
    let FBKeys: [String]
}

enum ResourceType {
    case Item, BodyThing
}

protocol LoadingType {
    associatedtype MyResourceType
    var spinner: UIActivityIndicatorView? { get set }
    func configureMe(item: MyResourceType, _ action: LoadingAction)
}

enum LoadingAction {
    case Removed
    case Added
}

enum Corn<A> {
    case Removed(Resource<A>)
    case Added
}

//TODO: Pass in .Removed or .Added at call site to remove repeated code
extension LoadingType where Self: UIViewController {
    func loadMe(r: Resource<MyResourceType>, withBlock: (MyResourceType?, LoadingAction) -> Void) {
        spinner?.startAnimating()
        r.RootRef.child(r.path).observeEventType(.ChildAdded) { (snapshot: FIRDataSnapshot) in
            withBlock(r.parse(snapshot.value as? FBDictionary, snapshot.key, r.path), .Added)
        }
        r.RootRef.child(r.path).observeEventType(.ChildRemoved) { (snapshot: FIRDataSnapshot) in
            withBlock(r.parse(snapshot.value as? FBDictionary, snapshot.key, r.path), .Removed)
        }
    }
}

protocol SendingType {
    associatedtype MyResourceType
}

extension SendingType where Self: UIViewController {
    func sendMe(resource r: Resource<MyResourceType>, valueToSend val: String) {
        print(val, val.wordsInString.count)
        print("path = \(r.path)")
        var fbDict: FBDictionary?
        switch r.resourceType {
        case .Item:      fbDict = val.toItemFBDictionary()
        case .BodyThing: print("BodyThing Type")
        }
        guard let dict = fbDict else { return }
        r.RootRef.child(r.path).childByAutoId().setValue(dict)
    }
}


class MyTableViewController<T>: UITableViewController, UITextFieldDelegate, LoadingType, SendingType {
    
    let resource: Resource<T>
    let configureCell: (UITableViewCell, T) -> ()
    let configureSelf: MyTableViewController -> ()
    var didSelect: T -> () = { _ in }
    var spinner: UIActivityIndicatorView?
    var items: [T] = []
    var nums: [Int] = []
    
    func configureMe(item: T, _ action: LoadingAction) {
        nums = nums.filter() { $0 != 3 }
        switch action {
        case .Added:
            spinner?.stopAnimating()
            items.append(item)
            tableView.reloadData()
        case .Removed: print("FUCK")
        }
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
        load()
    }
    
    private func load() {
        loadMe(resource) { [weak self] item, action in
            if let item = item {
                self?.configureMe(item, action)
            }
        }
    }
    
    // MARK: Textfield Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        if !text.isEmpty && text.wordsInString.count < 3 {
            sendMe(resource: resource, valueToSend: text)
            textField.clearText()
        }
        return true
    }

    // MARK: - Table view data source

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

}
