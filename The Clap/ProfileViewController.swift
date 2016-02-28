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

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    view.addSubview(quickView)
    Manuscript.layout(quickView) { view in
      view.alignAllEdges(to: self.view)
    }

    quickView.delegate = self
    
    navigationItem.title = "Your Tournaments"
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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

  }
}