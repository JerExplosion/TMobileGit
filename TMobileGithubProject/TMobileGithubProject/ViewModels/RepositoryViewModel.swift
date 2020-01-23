//
//  RepositoryViewModel.swift
//  TMobileGithubProject
//
//  Created by JerryRen on 1/22/20.
//  Copyright © 2020 JerryRen. All rights reserved.
//

import Foundation

final class RepositoryViewModel {
  private let repository: Repository
  
  var repoName: String {
    return self.repository.name
  }
  
  var numberOfForks: Int {
    return self.repository.forks
  }
  
  var numberOfStars: Int {
    return self.repository.stars
  }
  
  var htmlURL: URL {
    return self.repository.htmlURL
  }
  
  init(repo: Repository) {
    self.repository = repo
  }
}
