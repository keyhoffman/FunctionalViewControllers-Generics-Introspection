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
    
//    func resource(itemID: String) -> Resource<BodyThing> { return Resource(path: "bodyThing/\(itemID)", key: "bodyThingKey" , eventType: .ChildAdded, parse: BodyThing.init, needsAutoId: true, FBKeys: btKeys, resourceType: .BodyThing) }
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
    
    static let resource = Resource(path: "items", key: "itemsKey", eventType: .ChildAdded, parse: Item.init, needsAutoId: true, FBKeys: itemKeys, resourceType: .Item)
}

//extension Resource {
//    init?(resource: Resource<A>, data: [String:AnyObject], FBKeys: [String], key: String, path: String) {
//        for myKey in data.keys {
//            
//        }
//        for key in FBKeys {
//            guard let r = data[key] else { return nil }
//            print(r)
//        }
//    }
//}

let RootRef = FIRDatabase.database().reference()

typealias FBDictionary = [String:AnyObject]

struct Resource<A>: FirebaseObservable {
    let path: String
    let key: String
    let eventType: FIRDataEventType
//    let parse: (Resource, [String:AnyObject], [String], String, String) -> A?
    let parse: (FBDictionary?, [String], String, String) -> A?
    let needsAutoId: Bool
    let FBKeys: [String]
    let resourceType: ResourceType
    //let createNew: (String, String) -> A?
}

//let key: [String:AnyObject] = ["name":, "corn": Int]

enum ItemType {
    case Name(Item)
    case ItemMessage(Item)
    case AdditionalInformation(String)
    case IsCheckedOff(Bool)
}



enum ResourceType {
    case Item
    case BodyThing
}

//let itemKeys: [String:ItemType] = ["itemMessage":.ItemMessage, "name":.Name, "additionalInformation":.AdditionalInformation, "isCheckedOff":.IsCheckedOff]

//let newItemKeys: [String:ItemType] = ["itemMessage":.ItemMessage(Item.itemMessage), "name":.Name(<#T##Item#>)]

let fakeItemKeys: [String:Any.Type] = ["itemMessage" : String.self, "name" : String.self, "additionalInformation" : String.self, "isCheckedOff" : Bool.self]

let itemKeys = ["itemMessage", "name", "additionalInformation", "isCheckedOff"]

let btKeys = ["yummy", "color", "name"]


//TODO: MOVE Resources into extensions
//let itemResource = Resource(path: "items", key: "itemsKey", eventType: .ChildAdded, parse: Item.init, needsAutoId: true, FBKeys: itemKeys, resourceType: .Item)


func bodyThingResource(itemID: String) -> Resource<BodyThing> { return Resource(path: "bodyThing/\(itemID)", key: "bodyThingKey" , eventType: .ChildAdded, parse: BodyThing.init, needsAutoId: true, FBKeys: btKeys, resourceType: .BodyThing) }

let myItem = Item(key: "myKey", itemMessage: "myItemMessage", path: "myPath", name: "myName", additionalInformation: "myAddInfo", isCheckedOff: true)
let myItemMirror = Mirror(reflecting: myItem)

func loadResource<A>(resource: Resource<A>, withBlock: A? -> Void) {
    RootRef.child(resource.path).observeEventType(resource.eventType) { (snapshot: FIRDataSnapshot) in
        withBlock(resource.parse(snapshot.value as? FBDictionary, resource.FBKeys, snapshot.key, resource.path))
    }
}

//func loadResource<A>(resource: Resource<A>, withBlock: (A?) -> Void) {
//    print("myItemMirror = \(myItemMirror)")
//    print("myItemMirror childern = \(myItemMirror.children)")
//    print("myItemMirror description = \(myItemMirror.description)")
//    print("myItemMirrow subjectType = \(myItemMirror.subjectType)")
//    CustomReflectable.self
//    dump(myItem)
//    var mirrorArray: [(String?,Any)] = []
//    for case let (label?, value) in myItemMirror.children {
//        let labelMirror = Mirror(reflecting: label)
//        let valueMirror = Mirror(reflecting: value)
//        mirrorArray.append((label, valueMirror.subjectType))
////        print("Item valueMirror = \(valueMirror.subjectType)")
////        print("Item labelMirror = \(labelMirror.subjectType)")
////        print("myItemMirror(label?, value) = \(label, value)")
//    }
//    var i = 0
//    print("mirrorArray = \(mirrorArray)")
//    RootRef.child(resource.path).observeEventType(resource.eventType) { (snapshot: FIRDataSnapshot) in
//        withBlock(resource.parse(snapshot.value as? [String:AnyObject], resource.FBKeys, snapshot.key, resource.path))
//        if let data = snapshot.value as? [String:AnyObject] {
//            let dataMirror = Mirror(reflecting: data)
//            for (l, v) in mirrorArray {
//                guard let r = data[l!] else { continue }
//                switch r {
//                case let r as String: print("String -- \(l!, r, v)")
//                case let r as Bool:   print("Bool -- \(l!, r, v)")
//                default: print("FAIL"); continue
//                }
//            }
////            print("dataMirror = \(dataMirror)")
////            print("dataMirror[\(i)] = \(dataMirror.children)")
//            for case let (label?, value) in dataMirror.children {
//                let labelMirror = Mirror(reflecting: label)
//                let valueMirror = Mirror(reflecting: value)
////                print("valueMirror = \(valueMirror.subjectType)")
////                print("labelMirror = \(labelMirror.subjectType)")
////                print("dataMirror(label?, value = \(label, value)")
//            }
//            i += 1
//            //print(data)
//            withBlock(resource.parse(data, resource.FBKeys, snapshot.key, resource.path))
//        }
//        withBlock(nil)
//    }
//}

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
}

//FIXME: BRAH
extension LoadingType where Self: UIViewController {
    func load(resource: ResourceType) { item in
            if let item = item {
                //                print("load = \(self.resource)")
                //                print("loadResourceITEM = \(item)")
                self.spinner.stopAnimating()
                self.items.append(item)
                self.tableView.reloadData()
        }
    }
}


class MyTableViewController<T>: UITableViewController, UITextFieldDelegate {
    
    var items: [T] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    let resource: Resource<T>
    let configureCell: (UITableViewCell, T) -> ()
    let configureSelf: MyTableViewController -> ()
    var didSelect: T -> () = { _ in }
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    init(resource: Resource<T>, configureCell: (UITableViewCell, T) -> (), configureSelf: MyTableViewController -> ()) {
        self.resource = resource
        self.configureCell = configureCell
        self.configureSelf = configureSelf
        super.init(style: .Plain)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        spinner.center = view.center
        
        configureSelf(self)
        
        spinner.startAnimating()
        loadResource(resource) { item in
            if let item = item {
                //                print("load = \(self.resource)")
                //                print("loadResourceITEM = \(item)")
                self.spinner.stopAnimating()
                self.items.append(item)
                self.tableView.reloadData()
            }
        }
    }

    // MARK: Textfield Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let text = textField.text {
            //            if !text.isEmpty && text.wordsInString.count < 3 { print(text, text.wordsInString.count); sendResource(resource, itemToSend: text) }
            textField.text = ""
        }
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
