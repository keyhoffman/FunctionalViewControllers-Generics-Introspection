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
    
    private func pushVC<T>(sendingVC vc: MyViewController<T>) {
        let signUpVC = MyViewController(resource: vc.resource) {
            $0.title = "Sign Up"
            $0.view.backgroundColor = .blueColor()
            
            
            let emailTextField = UITextField()
            emailTextField.delegate = $0
            emailTextField.becomeFirstResponder()
            emailTextField.placeholder = "Enter your email"
            emailTextField.adjustsFontSizeToFitWidth = true
            emailTextField.autocapitalizationType = .None
            emailTextField.autocorrectionType = .No
            emailTextField.clearButtonMode = .Always
            emailTextField.keyboardAppearance = .Dark
            emailTextField.keyboardType = .EmailAddress
            emailTextField.returnKeyType = .Next
            emailTextField.frame = CGRect(x: 50, y: 150, width: 200, height: 21)
            
            $0.view.addSubview(emailTextField)
            $0.textFieldShouldReturn(textField: emailTextField, num: 7)
        }
        vc.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    /// MARK: The logic for opening flow
    /// Logic is only implemented if Firebase user request returns nil
    
    func openingFlow(completed: User -> Void) -> UINavigationController {
        
        let openingVC = MyViewController(resource: User.resource) { openvc in
            openvc.title = "Welcome to Line Bounce!"
            openvc.spinner = nil
            
            let button = BlockBarButtonItem(title: "Sign Up", style: .Plain) {
                self.pushVC(sendingVC: openvc)
            }
            openvc.navigationItem.rightBarButtonItem = button
        }
        let nav = UINavigationController(rootViewController: openingVC)
        return nav
    }
    
    /// MARK: The main app logic

    func mainApp(user user: User) -> UITabBarController {
        
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




