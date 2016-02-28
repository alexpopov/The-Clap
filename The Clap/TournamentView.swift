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
  let capacityLabel = UILabel()

  let divider = Divider()

  static var preferredHeight: CGFloat = 64

  override func createUI() {
    super.createUI()
    setupNameLabel() |> addSubview
    setupDateLabel() |> addSubview
    setupGameLabel() |> addSubview
    setupCapacityLabel() |> addSubview
    divider |> addSubview
  }

  override func layoutUI() {
    super.layoutUI()
    Manuscript.layout(nameLabel) { label in
      label.make(.Top, equalTo: self, s: .Top, plus: margin)
      label.make(.Leading, equalTo: self, s: .Leading, plus: 2 * margin)
      label.make(.Trailing, lessThan: self.dateLabel, s: .Leading)
    }
    Manuscript.layout(dateLabel) { label in
      label.make(.Baseline, equalTo: self.nameLabel, s: .Baseline)
      label.make(.Trailing, equalTo: self, s: .Trailing, minus: margin)
    }
    Manuscript.layout(gameLabel) { label in
      label.make(.Leading, equalTo: self.nameLabel, s: .Leading)
      label.make(.Bottom, equalTo: self, s: .Bottom, minus: margin)
      label.make(.Trailing, lessThan: self.capacityLabel, s: .Leading)
    }
    Manuscript.layout(divider) { divider in
      divider.make(.Leading, equalTo: self.nameLabel, s: .Leading)
      divider.make(.Trailing, equalTo: self, s: .Trailing)
      divider.make(.Bottom, equalTo: self, s: .Bottom)
    }
    Manuscript.layout(capacityLabel) { label in
      label.make(.Baseline, equalTo: self.gameLabel, s: .Baseline)
      label.make(.Trailing, equalTo: self, s: .Trailing, minus: margin)
    }
  }

  func setupNameLabel() -> UILabel {
    nameLabel.font = UIFont.systemFontOfSize(20, weight: UIFontWeightMedium)
    nameLabel.textColor = Colour.Blue.color
    return nameLabel
  }

  func setupDateLabel() -> UILabel {
    dateLabel.font = UIFont.systemFontOfSize(12, weight: UIFontWeightRegular)
    dateLabel.textColor = Colour.Grey.color
    return dateLabel
  }

  func setupGameLabel() -> UILabel {
    gameLabel.font = UIFont.italicSystemFontOfSize(16)
    gameLabel.textColor = Colour.Black.color
    return gameLabel
  }

  func setupCapacityLabel() -> UILabel {
    capacityLabel.font = UIFont.systemFontOfSize(12, weight: UIFontWeightRegular)
    capacityLabel.textColor = Colour.Grey.color
    return capacityLabel
  }

  func updateWithTournament(tournament: Tournament) {
    nameLabel.text = tournament.name
    gameLabel.text = tournament.game
    dateLabel.text = tournament.formattedDate
    capacityLabel.text = "\(tournament.current)/\(tournament.max) spots filled"
  }


}

