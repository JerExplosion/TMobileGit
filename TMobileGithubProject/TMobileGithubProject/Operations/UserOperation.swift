//
//  UserOperation.swift
//  TMobileGithubProject
//
//  Created by JerryRen on 1/22/20.
//  Copyright © 2020 JerryRen. All rights reserved.
//

import Foundation

final class UserOperation: Operation {
  private var userUpdateClosure: ((UserViewModel) -> Void)?
  private var errorClosure: ((Error) -> Void)?
  private var user: User? {
    didSet {
      guard let viewModel = self.userViewModel else { return }
      self.userUpdateClosure?(viewModel)
    }
  }
  
  private var error: Error? {
    didSet {
      guard let error = self.error else { return }
      self.errorClosure?(error)
    }
  }
  
  private let userURL: String
  private let session: Session
  private var userViewModel: UserViewModel? {
    guard let user = self.user else { return nil }
    return UserViewModel(user: user)
  }
  
  init(userURLString: String, session: Session = NetworkManager.shared) {
    self.userURL = userURLString
    self.session = session
  }
  
  override func main() {
    guard !self.isCancelled else { return }
    self.session.getModel(from: self.userURL, modelType: User.self) { [weak self] result in
      guard self?.isCancelled == false else { return }
      switch result {
      case .failure(let error):
        self?.error = error
      case .success(let user):
        self?.user = user
      }
    }
  }
  
  func update(with userClosure: @escaping (UserViewModel) -> Void) {
    if let userViewModel = self.userViewModel {
      userClosure(userViewModel)
    } else {
      self.userUpdateClosure = userClosure
    }
  }
  
  func updateError(_ errorClosure: @escaping (Error) -> Void) {
    if let error = self.error {
      errorClosure(error)
    } else {
      self.errorClosure = errorClosure
    }
  }
}
