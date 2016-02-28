//
//  Constants.swift
//  The Clap
//
//  Created by Alex Popov on 2016-02-27.
//  Copyright © 2016 Numbits. All rights reserved.
//

import Foundation
import UIKit
import HEXColor

enum Colour: String {
  case Blue = "#033261", White = "#FFFFFF", Yellow = "#ffe100", DarkBlue = ""

  var color: UIColor {
    return UIColor(rgba: self.rawValue)
  }
}
