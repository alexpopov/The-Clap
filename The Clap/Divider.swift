//
//  Divider.swift
//  BitLit
//
//  Created by Alex Popov on 2015-10-08.
//  Copyright © 2015 BitLit. All rights reserved.
//

import UIKit


@IBDesignable
class Divider: UIView {

  let divider = UIView()

  var yConstraint = NSLayoutConstraint()

  override init(frame: CGRect) {
    super.init(frame: frame)
    createUI()
    layoutUI()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    createUI()
    layoutUI()
  }

  func createUI() {
    self.backgroundColor = UIColor.clearColor()
    self.opaque = false
    divider.backgroundColor = Colour.Grey.color.colorWithAlphaComponent(0.2)
    self.addSubview(divider)
  }

  func layoutUI() {
    Manuscript.layout(divider) { divider in
      divider.makeHorizontalHairline()
      divider.make(.Leading, equalTo: self, s: .Leading)
      divider.make(.Trailing, equalTo: self, s: .Trailing)
      self.yConstraint = divider.make(.CenterY, equalTo: self, s: .CenterY).constraint
    }
  }

  override func intrinsicContentSize() -> CGSize {
    return CGSize(width: 0, height: 1)
  }

  func alignTop() {
    self.removeConstraint(yConstraint)
    Manuscript.layout(divider) { line in
      line.make(.Top, equalTo: self, s: .Top)
    }
  }

  func alignBottom() {
    self.removeConstraint(yConstraint)
    Manuscript.layout(divider) { line in
      line.make(.Bottom, equalTo: self, s: .Bottom)
    }
  }

}
