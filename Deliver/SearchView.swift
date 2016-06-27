//
//  SearchView.swift
//  Deliver
//
//  Created by Key Hoffman on 6/25/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

//import Foundation
//
//import UIKit
//import SnapKit
//
//protocol SearchViewDataSource: class {
//    func colorForSearchView(sender: SearchView) -> UIColor
//    func colorForSearchTextField(sender: SearchView) -> UIColor
//}
//
////protocol SearchBarDataSource: class {
////    <#requirements#>
////}
//
//class SearchBar: UISearchBar {
//
//
//}
//
//class SearchView: UIView {
//
//    weak var dataSource: SearchViewDataSource?
//
//    var searchTextField = UITextField()
//
//    func setShit() {
//        searchTextField.backgroundColor = dataSource?.colorForSearchTextField(self) ?? UIColor.blackColor()
//        self.addSubview(searchTextField)
//
//        self.snp_makeConstraints { (make) in
//            make.edges.equalTo(superview!)
//        }
//
//        searchTextField.snp_makeConstraints { (make) in
//            if let superview = superview {
//                make.left.equalTo(superview).offset(20)
//                make.right.equalTo(superview).inset(20)
//                make.bottom.equalTo(superview.snp_centerY).offset(200)
//                make.top.equalTo(superview.snp_centerY)
//            }
//        }
//
//        self.backgroundColor = dataSource?.colorForSearchView(self) ?? UIColor.blackColor()
//    }
//
//}

//let myItem = Item(key: "myKey", itemMessage: "myItemMessage", path: "myPath", name: "myName", additionalInformation: "myAddInfo", isCheckedOff: true)
//let myItemMirror = Mirror(reflecting: myItem)
//let fakeItemKeys: [String:Any.Type] = ["itemMessage" : String.self, "name" : String.self, "additionalInformation" : String.self, "isCheckedOff" : Bool.self]

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

