//
//  TournamentCell.swift
//  The Clap
//
//  Created by Alex Popov on 2016-02-27.
//  Copyright © 2016 Numbits. All rights reserved.
//

import UIKit

class TournamentCell: UITableViewCell {

  let subcell = TournamentView()

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }

  func setupUI() {
    contentView.addSubview(subcell)
    Manuscript.layout(subcell) { subcell in
      subcell.alignAllEdges(to: self.contentView)
    }
  }

  static var preferredHeight: CGFloat {
    return TournamentView.preferredHeight
  }


}
