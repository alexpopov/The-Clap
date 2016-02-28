//
//  TableView.swift
//  The Clap
//
//  Created by Alex Popov on 2016-02-27.
//  Copyright © 2016 Numbits. All rights reserved.
//

import UIKit

class TableView: UITableView {

  init(style: UITableViewStyle) {
    super.init(frame: CGRect.zero, style: style)
    setup()
  }

  convenience init() {
    self.init(style: .Plain)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setup() {
    self.translatesAutoresizingMaskIntoConstraints = false
    self.separatorInset = UIEdgeInsetsZero
    self.contentInset = UIEdgeInsetsZero
    self.backgroundColor = UIColor.whiteColor()
//    self.separatorStyle = .None
    self.showsVerticalScrollIndicator = false
    self.allowsSelection = true
  }

  


}
