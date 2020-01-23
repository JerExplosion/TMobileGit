//
//  ViewController.swift
//  TMobileGithubProject
//
//  Created by JerryRen on 1/21/20.
//  Copyright © 2020 JerryRen. All rights reserved.
//

import UIKit

final class GithubUserSearchViewController: UIViewController {
  @IBOutlet weak var usersTableView: UITableView!
  private var showingError = false
  
  let viewModel = UserSearchViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupTableView()
    self.navigationItem.title = self.viewModel.title
    self.createSearchController()
  }
  
  private func setupTableView() {
    self.usersTableView.dataSource = self
    self.usersTableView.delegate = self
    self.usersTableView.prefetchDataSource = self
    self.usersTableView.registerCell(UserTableViewCell.self)
  }
  
  private func showError() {
    //For future iteration, we could give the option for the user to log into GitHub
    //However, the current requirements do not have this functionality
    guard !self.showingError else { return }
    self.showingError = true
    let alert = UIAlertController(title: "Error", message: "We ran into a problem getting a user. If you are connected to the internet, we may have hit the limit for number of users we can get. Please wait an hour before trying again. We are working on a way to increase the number of users you can see in a later version", preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
      self?.showingError = false
    }
    alert.addAction(okAction)
    self.present(alert, animated: true, completion: nil)
  }
  
  private func createSearchController() {
    let searchController = UISearchController(searchResultsController: nil)
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = self.viewModel.searchPlaceholderText
    self.navigationItem.searchController = searchController
  }
}

extension GithubUserSearchViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let searchText = searchController.searchBar.text else { return }
    self.viewModel.getNewSearch(searchText) { [weak self] in
      DispatchQueue.main.async {
        self?.usersTableView.reloadData()
      }
    }
  }
}

extension GithubUserSearchViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.viewModel.numberOfUsers
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueCell(UserTableViewCell.self, indexPath: indexPath)
    cell.configure(with: nil)
    return cell
  }
}

extension GithubUserSearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let viewModel = self.viewModel.userViewModel(for: indexPath) else { return }
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let detailsViewController = storyboard.instantiateViewController(identifier: "UserDetailViewController") as! UserDetailViewController
    detailsViewController.viewModel = viewModel
    self.navigationController?.pushViewController(detailsViewController, animated: true)
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let cell = cell as? UserTableViewCell else { return }
    let lastRow = self.viewModel.numberOfUsers - 1
    if indexPath.row == lastRow {
      self.viewModel.getNewSearchResults {
        let newNumberOfRows = self.viewModel.numberOfUsers - 1
        let newIndexPaths = Array((lastRow + 1)...newNumberOfRows).map { IndexPath(row: $0, section: 0) }
        DispatchQueue.main.async {
          self.usersTableView.insertRows(at: newIndexPaths, with: .automatic)
        }
      }
    }
    //populate cell
    self.viewModel.retrieveUserIfAvailable(at: indexPath, success: { userViewModel in
      DispatchQueue.main.async {
        cell.configure(with: userViewModel)
      }
    }) { [weak self] error in
      DispatchQueue.main.async {
        self?.showError()
        cell.configureError(error)
      }
    }
  }
  
  func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    self.viewModel.cancelFetchingUsers(for: [indexPath])
  }
}

extension GithubUserSearchViewController: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    self.viewModel.startFetchingUsers(for: indexPaths)
  }
  
  func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
    self.viewModel.cancelFetchingUsers(for: indexPaths)
  }
}
