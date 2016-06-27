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

class MyTableViewController<T: FirebaseType>: UITableViewController, UITextFieldDelegate, LoadingType, SendingType {
    
    let resource: Resource<T>
    let configureCell: (UITableViewCell, T) -> ()
    let configureSelf: MyTableViewController -> ()
    var didSelect: T -> () = { _ in }
    var spinner: UIActivityIndicatorView?
    var items: [T] = []
    var nums: [Int] = []
    
    func configureMe(item: T, _ action: LoadingAction) {
        nums = nums.filter { $0 != 3 }
        switch action {
        case .Added:
            spinner?.stopAnimating()
            items.append(item)
            tableView.reloadData()
        case .Removed:
            if let idx = items.indexOf(item) {
                items.removeAtIndex(idx)
                tableView.reloadData()
            }
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
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            removeMe(resource: resource, valueToRemove: items[indexPath.row])
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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
