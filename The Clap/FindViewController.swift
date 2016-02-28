//
//  FindViewController.swift
//  The Clap
//
//  Created by Alex Popov on 2016-02-27.
//  Copyright © 2016 Numbits. All rights reserved.
//

import UIKit
import Prelude

class FindViewController: BaseViewController {

  let tableView = TableView()

  let reuseIdentifier = "tournament cell"

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    navigationItem.title = "Find Tournaments"
    setupTableView() |> view.addSubview
    Manuscript.layout(tableView) { table in
      table.alignAllEdges(to: self.view)
    }
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

extension FindViewController: UITableViewDataSource, UITableViewDelegate {

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
