//
//  TeamView.swift
//  The Clap
//
//  Created by Alex Popov on 2016-02-28.
//  Copyright © 2016 Numbits. All rights reserved.
//

import UIKit
import Prelude
import Bumblebee

class TeamView: BaseView {

  static let preferredHeight: CGFloat = 28

  let shortLabel = UILabel()
  let membersLabel = UILabel()

  let divider = Divider()

  override func createUI() {
    super.createUI()
    setupShortLabel() |> addSubview
    setupMembersLabel() |> addSubview
    divider |> addSubview
  }

  override func layoutUI() {
    super.layoutUI()
    Manuscript.layout(shortLabel) { label in
      label.make(.Leading, equalTo: self, s: .Leading, plus: 2 * margin)
      label.make(.CenterY, equalTo: self, s: .CenterY)
    }
    Manuscript.layout(membersLabel) { label in
      label.make(.Leading, equalTo: self.shortLabel, s: .Trailing, plus: margin)
      label.make(.Baseline, equalTo: self.shortLabel, s: .Baseline)
      label.make(.Trailing, lessThan: self, s: .Trailing, minus: margin)
    }
    Manuscript.layout(divider) { line in
      line.make(.Leading, equalTo: self.shortLabel, s: .Leading)
      line.make(.Trailing, equalTo: self, s: .Trailing)
      line.make(.Bottom, equalTo: self, s: .Bottom)
    }
  }

  let bumblebee = BumbleBee()

  func setupShortLabel() -> UILabel {
    shortLabel.textColor = Colour.Blue.color
    shortLabel.font = UIFont.systemFontOfSize(22, weight: UIFontWeightRegular)
    return shortLabel
  }

  func setupMembersLabel() -> UILabel {
    membersLabel.textColor = Colour.Black.color
    membersLabel.font = UIFont.systemFontOfSize(22, weight: UIFontWeightRegular)
    return membersLabel
  }

  func updateWithTeam(team: Team, player: Player) {
    shortLabel.text = team.shortName
    membersLabel.text = player.nickname
  }

}

class TeamCell: UITableViewCell {

  let subcell = TeamView()

  static var preferredHeight: CGFloat {
    return TeamView.preferredHeight
  }

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError()
  }

  func setupUI() {
    selectionStyle = .None
    contentView.addSubview(subcell)
    Manuscript.layout(subcell) { view in
      view.alignAllEdges(to: self.contentView)
    }
  }

}
