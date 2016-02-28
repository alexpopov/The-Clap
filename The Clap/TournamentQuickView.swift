//
//  TournamentQuickView.swift
//  The Clap
//
//  Created by Alex Popov on 2016-02-27.
//  Copyright © 2016 Numbits. All rights reserved.
//

import UIKit

protocol QuickViewDelegate: class {
  func showMoreInfo()
  func showHistory()
  func showFuture()
  func shareIP()
}

class TournamentQuickView: DesignableView {

  weak var delegate: QuickViewDelegate?

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
    delegate?.shareIP()
  }

  @IBOutlet var historyButton: UIButton! {
    didSet {
      let string = NSAttributedString(string: "History", attributes:
      [
        NSFontAttributeName : UIFont.systemFontOfSize(15, weight: UIFontWeightMedium),
        NSForegroundColorAttributeName : Colour.Blue.color
        ])
      historyButton.setAttributedTitle(string, forState: .Normal)
    }
  }
  @IBOutlet var futureButton: UIButton! {
    didSet {
      let string = NSAttributedString(string: "Coming up", attributes:
        [
          NSFontAttributeName : UIFont.systemFontOfSize(15, weight: UIFontWeightMedium),
          NSForegroundColorAttributeName : Colour.Blue.color
        ])
      futureButton.setAttributedTitle(string, forState: .Normal)
    }
  }


  func updateIP(ip: String) {
    let attributedString = NSAttributedString(string: ip, attributes:
      [
        NSFontAttributeName : UIFont.systemFontOfSize(16, weight: UIFontWeightMedium),
        NSForegroundColorAttributeName : Colour.LightBlue.color
      ])
    ipButton.setAttributedTitle(attributedString, forState: .Normal)
  }

  @IBAction func historyButtonPressed(sender: AnyObject) {
    delegate?.showHistory()
  }

  @IBAction func futureButtonPressed(sender: AnyObject) {
    delegate?.showFuture()
  }
  
  @IBAction func headerTapped(sender: UITapGestureRecognizer) {
    delegate?.showMoreInfo()
  }

  var timer: NSTimer?
  var upcomingMatch: UpcomingMatch?

  override func setupUI() {
    super.setupUI()
    timer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "updateTime", userInfo: nil, repeats: true)
  }

  func updateWithUpcomingMatch(upcomingMatch: UpcomingMatch) {
    self.upcomingMatch = upcomingMatch
    updateIP(upcomingMatch.match.ipAddress)
    teamLabel.text = upcomingMatch.otherTeam.name
    updateTime()

  }

  func updateTime() {
    guard let match = upcomingMatch else {
      return
    }
    let matchTime = match.match.date
    let timeDifference = matchTime.timeIntervalSinceNow
    let hoursAway = Int(abs(floor(timeDifference / 60 / 60 / 60)))
    let minutesAway = Int(abs(floor((timeDifference / 60) % 60)))
    if hoursAway < 24 {
      inLabel.text = "in"
      timeLabel.text = "\(hoursAway):\(minutesAway)"
    } else {
      let formatter = NSDateFormatter()
      formatter.dateFormat = "LLL d"
      inLabel.text = "on"
      timeLabel.text = formatter.stringFromDate(matchTime)
    }
    inLabel.text = "in"
    timeLabel.text = "3:47"
  }


}

class RoundedButton: UIButton {
  override func intrinsicContentSize() -> CGSize {
    let size = super.intrinsicContentSize()
    return CGSize(width: size.width + 16, height: size.height + 4)
  }
}