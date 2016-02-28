//
//  TournamentDetailsController.swift
//  The Clap
//
//  Created by Alex Popov on 2016-02-28.
//  Copyright © 2016 Numbits. All rights reserved.
//

import UIKit

class TournamentDetailsController: BaseViewController {

  let tournament: Tournament
  var tournamentDetails: TournamentDetails? {
    didSet {
      tableView.reloadData()
    }
  }
  let headerView = TournamentHeaderView()

  let tableView = TableView(style: .Grouped)

  let reuseIdentifier = "team cell"

  init(tournament: Tournament) {
    self.tournament = tournament
    super.init()
  }

  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    view.addSubview(headerView)
    view.backgroundColor = Colour.White.color
    Manuscript.layout(headerView) { view in
      view.make(.Leading, equalTo: self.view, s: .Leading)
      view.make(.Trailing, equalTo: self.view, s: .Trailing)
      view.make(.Top, equalTo: self.view, s: .Top)
    }

    headerView.updateWithTournament(tournament)
    API.getTournamentDetails(tournament.tournamentID)
      .onSuccess { self.tournamentDetails = $0 }

    setupTable()
  }

  func setupTable() {
    view.addSubview(tableView)
    Manuscript.layout(tableView) { table in
      table.make(.Leading, equalTo: self.view, s: .Leading)
      table.make(.Trailing, equalTo: self.view, s: .Trailing)
      table.make(.Top, equalTo: self.headerView, s: .Bottom)
      table.make(.Bottom, equalTo: self.view, s: .Bottom)
    }
    tableView.delegate = self
    tableView.dataSource = self
    tableView.registerClass(TeamCell.self, forCellReuseIdentifier: reuseIdentifier)
  }

}

extension TournamentDetailsController: UITableViewDelegate, UITableViewDataSource {

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! TeamCell
    if let details = tournamentDetails {
      let teamPlayers = details.teamPlayers[indexPath.section]
      cell.subcell.updateWithTeam(teamPlayers.team, player: teamPlayers.players[indexPath.row])
    }
    return cell
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let details = tournamentDetails else {
      return 0
    }
    let team = details.teamPlayers[section]
    return team.players.count
  }

  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    guard let details = tournamentDetails else {
      return 0
    }
    return details.teamPlayers.count
  }

  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 4
  }

  func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 4
  }

  func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let view = UIView()
    view.backgroundColor = Colour.LightBlue.color.colorWithAlphaComponent(0.1)
    return view
  }

  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = UIView()
    view.backgroundColor = Colour.LightBlue.color.colorWithAlphaComponent(0.1)
    return view
  }

  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return TeamCell.preferredHeight
  }

}
