//
//  TableViewCell.swift
//  TMobileGithubProject
//
//  Created by JerryRen on 1/22/20.
//  Copyright © 2020 JerryRen. All rights reserved.
//

import UIKit

final class UserTableViewCell: UITableViewCell, NibRegister {
  
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var userReposLabel: UILabel!
 
  private var imageOperation: ImageLoadOperation?
  private let operationQueue = OperationQueue()
  
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.imageOperation?.cancel()
    self.imageOperation = nil
  }
  
  func configure(with viewModel: UserViewModel?) {
    guard let viewModel = viewModel else {
      self.avatarImageView.image = nil
      self.avatarImageView.backgroundColor = .gray
      self.usernameLabel.text = "Loading..."
      self.userReposLabel.text = "Loading..."
      return
    }
    self.usernameLabel.text = viewModel.name
    self.userReposLabel.text = "Repos: \(viewModel.totalNumberOfRepos)"
    guard let imageURL = viewModel.avatarURL else { return }
    let imageOperation = ImageLoadOperation(imageURL: imageURL)
    imageOperation.update(self.updateWithImage(_:))
    self.imageOperation = imageOperation
    self.operationQueue.addOperation(imageOperation)
  }
  
  private func updateWithImage(_ image: UIImage) {
    DispatchQueue.main.async { [weak self] in
      self?.avatarImageView.image = image
      self?.avatarImageView.backgroundColor = .clear
    }
  }
  
  func configureError(_ error: Error) {
    self.avatarImageView.image = nil
    self.avatarImageView.backgroundColor = .gray
    self.usernameLabel.text = "Error getting user"
    self.userReposLabel.text = ""
    print(error)
  }
}
