//
//  TournamentHeaderView.swift
//  The Clap
//
//  Created by Alex Popov on 2016-02-28.
//  Copyright © 2016 Numbits. All rights reserved.
//

import UIKit

class TournamentHeaderView: DesignableView {

  @IBOutlet var titleLabel: UILabel! {
    didSet {
      titleLabel.textColor = Colour.Blue.color
    }
  }
  @IBOutlet var gameLabel: UILabel! {
    didSet {
      gameLabel.textColor = Colour.Grey.color
    }
  }
  @IBOutlet var dateLabel: UILabel! {
    didSet {
      dateLabel.textColor = Colour.Grey.color
    }
  }
  @IBOutlet var capacityLabel: UILabel! {
    didSet {
      capacityLabel.textColor = Colour.Grey.color
    }
  }

  func updateWithTournament(tournament: Tournament) {
    titleLabel.text = tournament.name
    gameLabel.text = tournament.game
    dateLabel.text = tournament.formattedDate
    capacityLabel.text = "\(tournament.current)/\(tournament.max)"
  }


}
