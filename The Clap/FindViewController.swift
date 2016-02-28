//
//  FindViewController.swift
//  The Clap
//
//  Created by Alex Popov on 2016-02-27.
//  Copyright © 2016 Numbits. All rights reserved.
//

import UIKit
import Prelude
import BrightFutures

class FindViewController: BaseViewController {

  let tableView = TableView()

  let reuseIdentifier = "tournament cell"

  var tournaments = [Tournament]() {
    didSet {
      let indexPaths = tournaments
        .enumerate()
        .map { $0.index }
        .map { NSIndexPath(forRow: $0, inSection: 0) }
      tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Top)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    navigationItem.title = "Find Tournaments"
    setupTableView() |> view.addSubview
    Manuscript.layout(tableView) { table in
      table.alignAllEdges(to: self.view)
    }
    API.getTournaments(filter: .Open).onSuccess { self.tournaments = $0 }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func setupTableView() -> TableView {
    tableView.registerClass(TournamentCell.self, forCellReuseIdentifier: reuseIdentifier)
    tableView.delegate = self
    tableView.dataSource = self
    return tableView
  }

}

extension FindViewController: UITableViewDataSource, UITableViewDelegate {

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! TournamentCell
    let tournament = tournaments[indexPath.row]
    cell.subcell.updateWithTournament(tournament)
    return cell
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tournaments.count
  }

  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return TournamentCell.preferredHeight
  }

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }

}
