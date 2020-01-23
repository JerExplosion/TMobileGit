//
//  UserSearchViewModel.swift
//  TMobileGithubProject
//
//  Created by JerryRen on 1/21/20.
//  Copyright © 2020 JerryRen. All rights reserved.
//

import Foundation

final class UserSearchViewModel {
  private var timer: Timer?
  private var currentSearchTerm: String?
  private let session: Session
  private var retrievedPage = 1
  private var currentError: Error?
  private var users: [SpecificUserResponse] = []
  private let operationQueue = OperationQueue()
  private var operations: [IndexPath: UserOperation] = [:]
  private var userViewModels: [IndexPath: UserViewModel] = [:]
  
  var searchPlaceholderText: String {
    return "Search for Users"
  }
  
  var title: String {
    return "GitHub Searcher"
  }
  
  var hasError: Bool {
    return currentError != nil
  }
  
  var numberOfUsers: Int {
    return self.users.count
  }
  
  init(session: Session = NetworkManager.shared) {
    self.session = session
  }
  
  func retrieveUserIfAvailable(at index: IndexPath, success: @escaping (UserViewModel) -> Void, error: @escaping (Error) -> Void) {
    if let operation = self.operations[index] {
      operation.update { [weak self] viewModel in
        self?.userViewModels[index] = viewModel
        success(viewModel)
      }
      operation.updateError(error)
    } else {
      self.createAndAddOperation(index)
      self.retrieveUserIfAvailable(at: index, success: success, error: error)
    }
  }
  
  func userViewModel(for index: IndexPath) -> UserViewModel? {
    return self.userViewModels[index]
  }
  
  fileprivate func createAndAddOperation(_ index: IndexPath) {
    let modelToUse = self.users[index.row]
    let newOperation = UserOperation(userURLString: modelToUse.userURL, session: self.session)
    self.operations[index] = newOperation
    self.operationQueue.addOperation(newOperation)
  }
  
  func startFetchingUsers(for indexPaths: [IndexPath]) {
    for index in indexPaths where self.operations[index] == nil {
      self.createAndAddOperation(index)
    }
  }
  
  func cancelFetchingUsers(for indexPaths: [IndexPath]) {
    for index in indexPaths {
      guard let operation = self.operations[index] else { break }
      operation.cancel()
      self.operations[index] = nil
    }
  }
  
  func getNewSearch(_ searchTerm: String, searchCompletion: @escaping () -> Void) {
    self.retrievedPage = 1
    self.cancelAllOperations()
    self.currentSearchTerm = searchTerm
    self.timer?.invalidate()
    self.users = []
    searchCompletion()
    self.timer = createTimer(searchCompletion)
  }
  
  private func cancelAllOperations() {
    for (index, operation) in self.operations {
      operation.cancel()
      self.operations[index] = nil
    }
  }
  
  private func createTimer(_ searchCompletion: @escaping () -> Void) -> Timer {
    return Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [weak self] _ in
      self?.getNewSearchResults(searchCompletion)
    }
  }
  
  func getNewSearchResults(_ completion: @escaping () -> Void) {
    guard let userSearchURL = self.getCurrentPageURL() else { return }
    self.session.getModel(from: userSearchURL, modelType: UserResponse.self) { [weak self] result in
      self?.parseUserResponse(result)
      completion()
    }
  }
  
  private func parseUserResponse(_ result: Result<UserResponse, Error>) {
    switch result {
    case .success(let userResponse):
      self.users += userResponse.items
    case .failure(let error):
      self.currentError = error
    }
  }
  
  private func getCurrentPageURL() -> String? {
    guard let currentSearch = self.currentSearchTerm else { return nil }
    defer { self.retrievedPage += 1 }
    return "https://api.github.com/search/users?q=\(currentSearch)&page=\(self.retrievedPage)"
  }
}
