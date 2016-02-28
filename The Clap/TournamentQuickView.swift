//
//  TournamentQuickView.swift
//  The Clap
//
//  Created by Alex Popov on 2016-02-27.
//  Copyright © 2016 Numbits. All rights reserved.
//

import UIKit

class TournamentQuickView: DesignableView {

  @IBOutlet var roundLabel: UILabel! {
    didSet {
      roundLabel.textColor = Colour.DarkBlue.color
    }
  }
  @IBOutlet var vsLabel: UILabel! {
    didSet {
      vsLabel.textColor = Colour.Grey.color
    }
  }
  @IBOutlet var teamLabel: UILabel! {
    didSet {
      teamLabel.textColor = Colour.DarkBlue.color
    }
  }

  @IBOutlet var inLabel: UILabel! {
    didSet {
      inLabel.textColor = Colour.Grey.color
    }
  }
  @IBOutlet var timeLabel: UILabel! {
    didSet {
      timeLabel.textColor = Colour.Blue.color
    }
  }

  @IBOutlet var ipButton: UIButton! {
    didSet {
      updateIP("192.168.107.1")
//      ipButton.titleEdgeInsets = UIEdgeInsets(top: -8, left: -8, bottom: -8, right: -8)
      ipButton.layer.borderColor = Colour.LightBlue.color.CGColor
      ipButton.layer.borderWidth = 1.0
      ipButton.layer.cornerRadius = 4
    }
  }

  @IBAction func ipPressed(sender: UIButton) {

  }

  func updateIP(ip: String) {
    let attributedString = NSAttributedString(string: ip, attributes:
      [
        NSFontAttributeName : UIFont.systemFontOfSize(16, weight: UIFontWeightMedium),
        NSForegroundColorAttributeName : Colour.LightBlue.color
      ])
    ipButton.setAttributedTitle(attributedString, forState: .Normal)
  }

}

class RoundedButton: UIButton {
  override func intrinsicContentSize() -> CGSize {
    let size = super.intrinsicContentSize()
    return CGSize(width: size.width + 16, height: size.height + 4)
  }
}