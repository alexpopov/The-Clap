//
//  ProfileViewController.swift
//  The Clap
//
//  Created by Alex Popov on 2016-02-27.
//  Copyright © 2016 Numbits. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {

  enum Section: Int {
    case Current = 0, Future, Past
  }

  let tableView = TableView(style: .Grouped)

  let reuseIdentifier = "tournament cells"

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    navigationItem.title = "Your Tournaments"
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func setupTableView() -> TableView {
    tableView.registerClass(TournamentCell.self, forCellReuseIdentifier: reuseIdentifier)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = .SingleLine
    return tableView
  }


}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {

  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 3
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! TournamentCell

    return cell
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }

  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return TournamentCell.preferredHeight
  }

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }


}
