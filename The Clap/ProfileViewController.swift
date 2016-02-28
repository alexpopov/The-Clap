//
//  ProfileViewController.swift
//  The Clap
//
//  Created by Alex Popov on 2016-02-27.
//  Copyright © 2016 Numbits. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {

  let quickView = TournamentQuickView()

  let tableView = TableView(style: .Grouped)

  let reuseIdentifier = "tournament cells"

  var upcomingMatch: UpcomingMatch? {
    didSet {
      quickView.hidden = false
      guard let upcomingMatch = upcomingMatch else {
        return
      }
      quickView.updateWithUpcomingMatch(upcomingMatch)
    }
  }

  let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    quickView.hidden = true
    view.addSubview(quickView)
    Manuscript.layout(quickView) { view in
      view.alignAllEdges(to: self.view)
    }

    quickView.delegate = self
    
    navigationItem.title = "Your Tournaments"
    API.getUpcomingMatch().onSuccess { self.upcomingMatch = $0 }
      .onComplete { _ in self.activityIndicator.stopAnimating() }


    activityIndicator.hidesWhenStopped = true
    activityIndicator.startAnimating()
    view.addSubview(activityIndicator)
    Manuscript.layout(activityIndicator) { $0.centerIn(self.view) }
  }

}

extension ProfileViewController: QuickViewDelegate {
  func showMoreInfo() {
    
  }

  func showFuture() {
    let controller = FindViewController(tournamentFilter: .Future)
    navigationController?.pushViewController(controller, animated: true)
  }

  func showHistory() {
    let controller = FindViewController(tournamentFilter: .Past)
    navigationController?.pushViewController(controller, animated: true)
  }

  func shareIP() {
    guard let upcomingMatch = upcomingMatch else {
      return
    }
    let ipAddress = upcomingMatch.match.ipAddress
    ShareBear(viewController: self).shareText(ipAddress, andOther: nil)
    UIPasteboard.generalPasteboard().string = ipAddress
  }
}