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
