//
//  BaseView.swift
//  The Clap
//
//  Created by Alex Popov on 2016-02-27.
//  Copyright © 2016 Numbits. All rights reserved.
//

import UIKit

class BaseView: UIView {

  init() {
    super.init(frame: CGRect.zero)
    createUI()
    layoutUI()
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }

  func createUI() {

  }

  func layoutUI() {

  }

}
