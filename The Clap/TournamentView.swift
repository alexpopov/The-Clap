//
//  TournamentView.swift
//  The Clap
//
//  Created by Alex Popov on 2016-02-27.
//  Copyright © 2016 Numbits. All rights reserved.
//

import UIKit
import Prelude

class TournamentView: BaseView {

  let nameLabel = UILabel()
  let dateLabel = UILabel()
  let gameLabel = UILabel()

  let divider = Divider()

  static var preferredHeight: CGFloat = 64

  override func createUI() {
    super.createUI()
    setupNameLabel() |> addSubview
    setupDateLabel() |> addSubview
    setupGameLabel() |> addSubview
    divider |> addSubview
  }

  override func layoutUI() {
    super.layoutUI()
    Manuscript.layout(nameLabel) { label in
      label.make(.Top, equalTo: self, s: .Top, plus: margin)
      label.make(.Leading, equalTo: self, s: .Leading, plus: 2 * margin)
    }
    Manuscript.layout(dateLabel) { label in
      label.make(.Baseline, equalTo: self.nameLabel, s: .Baseline)
      label.make(.Trailing, equalTo: self, s: .Trailing, minus: margin)
    }
    Manuscript.layout(gameLabel) { label in
      label.make(.Leading, equalTo: self.nameLabel, s: .Leading)
      label.make(.Bottom, equalTo: self, s: .Bottom, minus: margin)
    }
    Manuscript.layout(divider) { divider in
      divider.make(.Leading, equalTo: self.nameLabel, s: .Leading)
      divider.make(.Trailing, equalTo: self, s: .Trailing)
      divider.make(.Bottom, equalTo: self, s: .Bottom)
    }
  }

  func setupNameLabel() -> UILabel {
    nameLabel.font = UIFont.systemFontOfSize(20, weight: UIFontWeightRegular)
    nameLabel.textColor = Colour.DarkBlue.color
    return nameLabel
  }

  func setupDateLabel() -> UILabel {
    dateLabel.font = UIFont.systemFontOfSize(12, weight: UIFontWeightRegular)
    dateLabel.textColor = Colour.Grey.color
    return dateLabel
  }

  func setupGameLabel() -> UILabel {
    gameLabel.font = UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
    gameLabel.textColor = Colour.Black.color
    return gameLabel
  }

  func updateWithTournament(tournament: Tournament) {
    nameLabel.text = tournament.name
    gameLabel.text = tournament.game
    let formatter = NSDateFormatter()
    formatter.dateFormat = "dd/MM/YYYY"
    dateLabel.text = formatter.stringFromDate(tournament.date)
  }


}

