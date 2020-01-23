//
//  UserDetailViewController.swift
//  TMobileGithubProject
//
//  Created by JerryRen on 1/22/20.
//  Copyright © 2020 JerryRen. All rights reserved.
//

import UIKit
import SafariServices

final class UserDetailViewController: UIViewController {
  
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var joinDateLabel: UILabel!
  @IBOutlet weak var followersLabel: UILabel!
  @IBOutlet weak var followingLabel: UILabel!
  @IBOutlet weak var biographyLabel: UILabel!
  @IBOutlet weak var repoSearchBar: UISearchBar!
  @IBOutlet weak var repoTableView: UITableView!
  
  var viewModel: UserViewModel!
  private var operationQueue = OperationQueue()
  private var imageOperation: ImageLoadOperation?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupLabels()
    self.setupSearchBar()
    self.setupTableView()
    self.getImageIfPossible()
    self.viewModel.getRepositories(with: nil) { [weak self] in
      DispatchQueue.main.async {
        self?.repoTableView.reloadData()
      }
    }
  }
  
  private func getImageIfPossible() {
    guard let avatarImageURL = self.viewModel.avatarURL else { return }
    let imageOperation = ImageLoadOperation(imageURL: avatarImageURL)
    imageOperation.update { image in
      DispatchQueue.main.async {
        self.avatarImageView.image = image
      }
    }
    self.imageOperation = imageOperation
    self.operationQueue.addOperation(imageOperation)
  }
  
  private func setupTableView() {
    self.repoTableView.dataSource = self
    self.repoTableView.delegate = self
    self.repoTableView.registerCell(RepositoryTableViewCell.self)
  }
  
  private func setupSearchBar() {
    self.repoSearchBar.delegate = self
    self.repoSearchBar.placeholder = "Search for User's Repositories"
  }
  
  private func setupLabels() {
    self.usernameLabel.text = "Username: \(self.viewModel.name)"
    self.emailLabel.text = "Email: \(self.viewModel.email ?? "No Email")"
    self.locationLabel.text = "Location: \(self.viewModel.location ?? "No Location")"
    self.joinDateLabel.text = "Join Date: \(self.viewModel.joinDate)"
    self.followersLabel.text = "\(self.viewModel.numberOfFollowers) Followers"
    self.followingLabel.text = "Following \(self.viewModel.numberFollowing)"
    self.biographyLabel.text = self.viewModel.biography
  }
}

extension UserDetailViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    self.viewModel.getRepositories(with: searchText) { [weak self] in
      DispatchQueue.main.async {
        self?.repoTableView.reloadData()
      }
    }
  }
}

extension UserDetailViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.viewModel.numberOfRepos
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueCell(RepositoryTableViewCell.self, indexPath: indexPath)
    let repoViewModel = self.viewModel.repositoryViewModel(for: indexPath.row)
    cell.configure(with: repoViewModel)
    return cell
  }
}

extension UserDetailViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let url = self.viewModel.repositoryViewModel(for: indexPath.row).htmlURL
    let webView = SFSafariViewController(url: url)
    self.present(webView, animated: true, completion: nil)
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let lastRow = self.viewModel.numberOfRepos - 1
    if indexPath.row == lastRow {
      self.viewModel.getRepositories(with: self.repoSearchBar.text!, isMore: true) {
        let newNumberOfRows = self.viewModel.numberOfRepos - 1
        let newIndexPaths = Array((lastRow + 1)...newNumberOfRows).map { IndexPath(row: $0, section: 0) }
        DispatchQueue.main.async {
          self.repoTableView.insertRows(at: newIndexPaths, with: .automatic)
        }
      }
    }
  }
}
