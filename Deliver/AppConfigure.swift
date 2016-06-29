//
//  AppConfigure.swift
//  Deliver
//
//  Created by Key Hoffman on 6/25/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation
import UIKit

final class MainAppFlow: NSObject {
    
    func please(vc: Int -> Void) {
        vc(5)
    }
    
    func openingFlow(completed: User -> Void) -> UINavigationController {
        
        let openingVC = MyViewController(resource: User.resource) {
            $0.title = "Welcome to Line Bounce!"
            
            $0.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Up", style: .Plain, target: $0, action: #selector($0.work))
            
        }
        openingVC.d = { item in }
        let nav = UINavigationController(rootViewController: openingVC)
        
        return nav
    }

    func mainApp(user user: User) -> UITabBarController {
        
        /// TODO: Add $ syntax for closure type inference
        var i = 0
        let myListViewController = MyTableViewController(resource: Item.resource, configureCell: {
            $0.textLabel?.text = "[\(i)]" + $1.name
            $0.detailTextLabel?.text = $1.additionalInformation
            $0.accessoryType = $1.isCheckedOff ? .Checkmark : .DisclosureIndicator
            i += 1
        }) {
            $0.spinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            $0.spinner?.addToSuperView($0)
            
            $0.navigationItem.rightBarButtonItem = $0.editButtonItem()
            
            let textField = UITextField()
            textField.delegate = $0
            textField.placeholder = "Search for items"
            textField.frame = CGRectMake(0, 0, $0.navigationController?.navigationBar.frame.size.width ?? 0, 21)
            $0.navigationItem.titleView = textField
            
            $0.textFieldShouldReturn(textfield: textField, resource: $0.resource)
            
    //        $0.textFieldShouldReturn(textField)
        }
        let nav1 = UINavigationController(rootViewController: myListViewController)
        myListViewController.didSelect = {
            let bodyThingVC = MyTableViewController(resource: $0.bodyThings, configureCell: {
                $0.textLabel?.text = $1.name
                $0.detailTextLabel?.text = $1.color
                $0.accessoryType = $1.isYummy ? .Checkmark : .DisclosureIndicator
                $0.selectionStyle = .None
            }) { $0.title = "BodyThing Yo" }
            nav1.pushViewController(bodyThingVC, animated: true)
        }
        nav1.tabBarItem = UITabBarItem(title: "My List", image: nil, tag: 0)
        
        let currentOffersViewController = UIViewController()
        
    //    let currentOffersViewController = MyTableViewController(resource: <#T##Resource<T>#>, configureCell: { (<#UITableViewCell#>, <#T#>) in
    //        <#code#>
    //        }) { (<#MyTableViewController<T>#>) in
    //            <#code#>
    //    }
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
}




