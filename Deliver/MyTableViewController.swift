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

class MyTableViewController<T: FirebaseType>: UITableViewController, UITextFieldDelegate, LoadingDisplayType, SendingDisplayType, Configurable {
    
    let resource: Resource<T>
    private let configureCell: (UITableViewCell, T) -> Void
    private var items: [T] = []
    let configureSelf: MyTableViewController -> Void
    var spinner: UIActivityIndicatorView?
    var didSelect: T -> Void = { _ in }
    
    internal func configureMe(item: T, _ eventType: FIRDataEventType) {
        switch eventType {
        case .ChildAdded:
            spinner?.stopAnimating()
            items.append(item)
            tableView.reloadData()
        case .ChildRemoved:
            if let idx = items.indexOf(item) {
                items.removeAtIndex(idx)
                tableView.reloadData()
            }
        case .ChildChanged: break
        case .ChildMoved:   break
        case .Value:        break
        }
        
    }
    
    init(resource: Resource<T>, configureCell: (UITableViewCell, T) -> Void, configureSelf: MyTableViewController -> Void) {
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
    
    private func load() { loadMe(resource) { [ weak self ] in if let $ = $0 { self?.configureMe($, $1) } } }
    
    // MARK: Textfield Delegate
    
//    //FIXME: This is not Generic!!
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        guard let text = textField.text else { return false }
//        if !text.isEmpty && text.wordsInString.count < 3 {
//            sendMe(resource: resource, valueToSend: text)
//            textField.clearText()
//        }
//        return true
//    }

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
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete: removeMe(resource: resource, valueToRemove: items[indexPath.row])
        case .Insert: break
        case .None:   break
        }
    }

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
