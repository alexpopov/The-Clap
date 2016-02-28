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

  let filter: TournamentFilter

  let emptyStateLabel = UILabel()

  init(tournamentFilter: TournamentFilter) {
    self.filter = tournamentFilter
    super.init()
  }

  required init?(coder: NSCoder?) {
    fatalError()
  }

  let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    navigationItem.title = {
      switch self.filter {
      case .Future: return "Coming Up"
      case .Open: return "Find Tournaments"
      case .Past: return "Tournament History"
      }
    }()
    setupTableView() |> view.addSubview
    Manuscript.layout(tableView) { table in
      table.alignAllEdges(to: self.view)
    }
    API.getTournaments(filter: filter)
      .onSuccess { self.tournaments = $0 }
      .onComplete { result in
        self.activityIndicator.stopAnimating()
        if result.value == nil {
          self.emptyStateLabel.hidden = false
          self.emptyStateLabel.text = "Oops :("
        } else if result.value?.isEmpty == true {
          self.emptyStateLabel.hidden = false
        }
    }

    setupSpinner()

    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tripleTapped")
    tapGestureRecognizer.numberOfTapsRequired = 3
    navigationController?.navigationBar.addGestureRecognizer(tapGestureRecognizer)

    emptyStateLabel.text = {
      switch self.filter {
      case .Future:
        return "You need to join a tournament :)"
      case .Open:
        return "Check back soon for more tournaments!"
      case .Past:
        return "Gotta start somewhere!"
      }
    }()
    emptyStateLabel.textColor = Colour.Grey.color
    emptyStateLabel.font = UIFont.italicSystemFontOfSize(16)
    emptyStateLabel.numberOfLines = 0
    view.addSubview(emptyStateLabel)
    emptyStateLabel.hidden = true
    emptyStateLabel.textAlignment = .Center
    Manuscript.layout(emptyStateLabel) { label in
      label.make(.Top, equalTo: self.view, s: .Top, plus: 3 * margin)
      label.make(.Width, equalTo: self.view, s: .Width, minus: 4 * margin)
      label.make(.CenterX, equalTo: self.view, s: .CenterX)
    }
  }

  func tripleTapped() {
    let alertController = UIAlertController(title: "DEBUG MAGIC", message: nil, preferredStyle: .Alert)
    alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
      textField.placeholder = "IP Address"
    }
    alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
      textField.placeholder = "User ID"
    }
    alertController.addAction(UIAlertAction(title: "Okay", style: .Default, handler: { (action) -> Void in
      let ipTextField = alertController.textFields?.first
      if let ipAddress = ipTextField?.text where ipAddress.isEmpty == false {
        Client.ipAddress = ipAddress
      }
      if let userIDText = alertController.textFields?.last?.text, let newUserID = Int(userIDText) where newUserID > 0 {
        Client.userID = newUserID
      }
    }))
    presentViewController(alertController, animated: true, completion: nil)
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

  func setupSpinner() {
    view.addSubview(activityIndicator)
    Manuscript.layout(activityIndicator) { $0.centerIn(self.view) }
    activityIndicator.hidesWhenStopped = true
    activityIndicator.startAnimating()
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
    let tournament = tournaments[indexPath.row]
    let controller = TournamentDetailsController(tournament: tournament)
    navigationController?.pushViewController(controller, animated: true)
  }

}
