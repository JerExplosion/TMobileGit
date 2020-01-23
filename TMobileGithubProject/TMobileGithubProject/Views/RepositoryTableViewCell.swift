//
//  RepositoryTableViewCell.swift
//  TMobileGithubProject
//
//  Created by JerryRen on 1/22/20.
//  Copyright © 2020 JerryRen. All rights reserved.
//

import UIKit

final class RepositoryTableViewCell: UITableViewCell, NibRegister {

  @IBOutlet weak var repoNameLabel: UILabel!
  @IBOutlet weak var forksLabel: UILabel!
  @IBOutlet weak var starsLabel: UILabel!
  
  func configure(with viewModel: RepositoryViewModel) {
    self.repoNameLabel.text = viewModel.repoName
    self.forksLabel.text = "\(viewModel.numberOfForks) Forks"
    self.starsLabel.text = "\(viewModel.numberOfStars) Stars"
  }
}
