//
//  AppConfigure.swift
//  Deliver
//
//  Created by Key Hoffman on 6/25/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation
import UIKit

final class MainAppFlow {
    
    private func pushVC<T>(sendingViewController sendingVC: MyViewController<T>, viewControllerAction action: OpeningAction, withBlock: User -> Void) {
        print("action = \(action)")
        let pushedVC = MyViewController(resource: sendingVC.resource) { pvc in
            let actionView = OpeningActionView(parentViewController: pvc)
    
            pvc.title = action.rawValue
            pvc.view.backgroundColor = .cyanColor()
            pvc.view.addSubview(actionView)
        }
        sendingVC.navigationController?.pushViewController(pushedVC, animated: true)
        pushedVC.textFieldReturnWasPressed = { textField in
            guard let text = textField.text else { throw TextFieldError.TextWasEmpty("Invalid text input") }
            if !text.isEmpty {
                switch textField.tag {
                case 0:
                    textField.resignFirstResponder()
                    User.authEmail = text
                    pushedVC.view.viewWithTag(1)?.hidden = false
                    pushedVC.view.viewWithTag(1)?.becomeFirstResponder()
                case 1:
                    User.authPassword = text
                    User().authorizeUser(authorizeAction: action) { firUser, error in
                        if let err = error { print(err.localizedDescription) } /// FIXME: fix the error printout 
                        else if let firUser = firUser, let email = firUser.email {
                            let user = User(key: firUser.uid, name: "NoNameSet", email: email)
                            switch action {
                            case .Login: print("Login Sucess!!!s"); break
                            case .SignUp: user.sendToFB()
                            }
                            withBlock(user)
                        } else { fatalError("WTF!!!") }
                    }
                default: throw TextFieldError.TextWasEmpty("Invalid text fields")
                }
            } else {
                throw TextFieldError.TextWasEmpty("Please enter a value")
            }
        }
    }
    
    /// MARK: The logic for opening flow
    /// Logic is only implemented if Firebase user request returns nil
    
    func openingFlow(completed: User -> Void) -> UINavigationController {
        
        let openingVC = MyViewController(resource: User.resource) { openvc in
            let signUpButton = BlockBarButtonItem(title: "Sign Up", style: .Plain) {
                self.pushVC(sendingViewController: openvc, viewControllerAction: .SignUp) { completed($0) }
            }
            
            let loginButton = BlockBarButtonItem(title: "Login", style: .Plain) {
                self.pushVC(sendingViewController: openvc, viewControllerAction: .Login) { completed($0) }
            }
            
            openvc.title = "Welcome to Line Bounce!"
            openvc.view.backgroundColor = .lightGrayColor()
            openvc.navigationItem.rightBarButtonItem = signUpButton
            openvc.navigationItem.leftBarButtonItem  = loginButton
        }
        let nav = UINavigationController(rootViewController: openingVC)
        
        return nav
    }
    
    /// MARK: The main app logic

    func mainApp(user user: User) -> UITabBarController {
        
        var i = 0
        let myListViewController = MyTableViewController(resource: Item.resource, configureCell: { cell, item in
            cell.textLabel?.text = "[\(i)]" + item.name
            cell.detailTextLabel?.text = item.additionalInformation
            cell.accessoryType = item.isCheckedOff ? .Checkmark : .DisclosureIndicator
            i += 1
        }) { myListVC in
            let searchTextField = SearchTextField(frame: CGRect(x: 0, y: 0, width: myListVC.navigationController?.navigationBar.frame.size.width ?? 0, height: 21), delegate: myListVC, searchForPlaceholder: "items")
            
            myListVC.spinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
//            myListVC.spinner?.addToSuperView(myListVC)
            myListVC.navigationItem.rightBarButtonItem = myListVC.editButtonItem()
            myListVC.navigationItem.titleView = searchTextField
        }
        let nav1 = UINavigationController(rootViewController: myListViewController)
        myListViewController.didSelect = {
            let bodyThingVC = MyTableViewController(resource: $0.bodyThings, configureCell: { cell, bodyThing in
                cell.textLabel?.text = bodyThing.name
                cell.detailTextLabel?.text = bodyThing.color
                cell.accessoryType = bodyThing.isYummy ? .Checkmark : .DisclosureIndicator
                cell.selectionStyle = .None
            }) { bodyVC in bodyVC.title = "BodyThing Yo" }
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
}




