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
//      view.make(.Leading, equalTo: self.view, s: .Leading)
//      view.make(.Trailing, equalTo: self.view, s: .Trailing)
//      view.make(.Top, equalTo: self.view, s: .Top)
      view.alignAllEdges(to: self.view)
    }
    
    navigationItem.title = "Your Tournaments"
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}
