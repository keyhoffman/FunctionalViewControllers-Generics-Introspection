//
//  AppConfigure.swift
//  Deliver
//
//  Created by Key Hoffman on 6/25/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation
import UIKit

func app() -> UITabBarController {
    
    let myListViewController = MyTableViewController(resource: Item.resource, configureCell: { cell, item in
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.additionalInformation
        cell.accessoryType = item.isCheckedOff ? .Checkmark : .DisclosureIndicator
    }) { myListVC in
        myListVC.spinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        myListVC.spinner?.addToSuperView(myListVC)
        
        let navButt = UIBarButtonItem(barButtonSystemItem: .Add, target: myListVC, action: nil)
        myListVC.navigationItem.rightBarButtonItem = navButt
        
        let textField = UITextField()
        textField.delegate = myListVC
        textField.placeholder = "Search for items"
        textField.frame = CGRectMake(0, 0, myListVC.navigationController?.navigationBar.frame.size.width ?? 0, 21)
        myListVC.navigationItem.titleView = textField
        
        myListVC.textFieldShouldReturn(textField)
    }
    let nav1 = UINavigationController(rootViewController: myListViewController)
    myListViewController.didSelect = { item in
        let bodyThingVC = MyTableViewController(resource: item.bodyThings, configureCell: { cell, bodyThing in
            cell.textLabel?.text = bodyThing.name
            cell.detailTextLabel?.text = bodyThing.color
            cell.accessoryType = bodyThing.isYummy ? .Checkmark : .DisclosureIndicator
            cell.selectionStyle = .None
        }) { bodyVC in bodyVC.title = "BodyThing Yo"}
        nav1.pushViewController(bodyThingVC, animated: true)
    }
    nav1.tabBarItem = UITabBarItem(title: "My List", image: nil, tag: 0)
    
    let currentOffersViewController = UIViewController()
    currentOffersViewController.title = "Browse Current Offers"
    let nav2 = UINavigationController(rootViewController: currentOffersViewController)
    nav2.tabBarItem = UITabBarItem(title: "Current Offers", image: nil, tag: 1)
    
    let userProfileViewController = UIViewController()
    userProfileViewController.title = "Profile"
    let nav3 = UINavigationController(rootViewController: userProfileViewController)
    nav3.tabBarItem = UITabBarItem(title: "Profile", image: nil, tag: 2)
    
    
    let myTabController = UITabBarController()
    myTabController.viewControllers = [nav1, nav2, nav3]
    
    return myTabController
    
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
    
    func toItemFBDictionary() -> FBDictionary {
        let wordsArray = self.componentsSeparatedByString(" ")
        var fbDict: FBDictionary = [:]
        fbDict["name"]                  = wordsArray[0]
        fbDict["additionalInformation"] = wordsArray.count < 2 || wordsArray.count > 2 ? "" : wordsArray[1][wordsArray[1].startIndex] == "#" ? wordsArray[1] : ""
        fbDict["itemMessage"]           = self
        fbDict["isCheckedOff"]          = false
        
        return fbDict
    }
}


