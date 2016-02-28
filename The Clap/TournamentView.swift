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



  static var preferredHeight: CGFloat = 56

  override func createUI() {
    super.createUI()
    setupNameLabel() |> addSubview
    setupDateLabel() |> addSubview
    setupGameLabel() |> addSubview
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
  }

  func setupNameLabel() -> UILabel {
    nameLabel.font = UIFont.systemFontOfSize(18, weight: UIFontWeightRegular)
    nameLabel.textColor = Colour.DarkBlue.color
    nameLabel.text = "NA LCS"
    return nameLabel
  }

  func setupDateLabel() -> UILabel {
    dateLabel.font = UIFont.systemFontOfSize(12, weight: UIFontWeightRegular)
    dateLabel.textColor = Colour.Grey.color
    dateLabel.text = "27/02/16"
    return dateLabel
  }

  func setupGameLabel() -> UILabel {
    gameLabel.font = UIFont.systemFontOfSize(15, weight: UIFontWeightRegular)
    gameLabel.textColor = Colour.Black.color
    gameLabel.text = "League of Legends"
    return gameLabel
  }



}

