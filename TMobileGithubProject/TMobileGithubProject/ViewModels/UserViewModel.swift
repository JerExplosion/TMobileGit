//
//  UserViewModel.swift
//  TMobileGithubProject
//
//  Created by JerryRen on 1/21/20.
//  Copyright © 2020 JerryRen. All rights reserved.
//

import Foundation

final class UserViewModel {
  private let user: User
  private let session: Session
  private var repositories: [Repository] = []
  private var page = 1
  private var currentError: Error?
  private var searchTerm: String?
  private var timer: Timer?
  
  var name: String {
    return self.user.name ?? "No Name"
  }
  
  var totalNumberOfRepos: Int {
    return self.user.numberOfPublicRepos
  }
  
  var numberOfRepos: Int {
    return self.repositories.count
  }
  
  var avatarURL: String? {
    return self.user.avatarURL
  }
  
  var email: String? {
    return self.user.email
  }
  
  var location: String? {
    return self.user.location
  }
  
  var joinDate: String {
    return self.user.joinDate
  }
  
  var numberOfFollowers: Int {
    return self.user.numberOfFollowers
  }
  
  var numberFollowing: Int {
    return self.user.numberFollowing
  }
  
  var biography: String? {
    return self.user.biography
  }
  
  init(user: User, session: Session = NetworkManager.shared) {
    self.user = user
    self.session = session
  }
  
  func repositoryViewModel(for index: Int)-> RepositoryViewModel {
    return RepositoryViewModel(repo: self.repositories[index])
  }
  
  private func getRepos(with search: String?, isMore: Bool, completion: @escaping () -> Void) {
    self.session.getModel(from: self.getReposURL(with: search), modelType: RepositoryResponse.self) { [weak self] result in
      switch result {
      case .success(let response):
        if isMore {
          self?.repositories += response.items
        } else {
          self?.repositories = response.items
        }
      case .failure(let error):
        self?.currentError = error
      }
      completion()
    }
  }
  
  func getRepositories(with search: String?, isMore: Bool = false, completion: @escaping () -> Void) {
    if search != self.searchTerm {
      self.page = 1
    }
    self.searchTerm = search
    if self.searchTerm != nil && !isMore {
      self.timer?.invalidate()
      self.timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { [weak self] _ in
        self?.getRepos(with: search, isMore: isMore, completion: completion)
      })
    } else {
      self.getRepos(with: search, isMore: isMore, completion: completion)
    }
  }
  
  private func getReposURL(with term: String?) -> String {
    guard let name = self.user.login.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return "" }
    defer { self.page += 1 }
    if let term = term {
      return "https://api.github.com/search/repositories?q=\(term)+user:\(name)&page=\(self.page)"
    } else {
      return "https://api.github.com/search/repositories?q=user:\(name)&page=\(self.page)"
    }
  }
}
