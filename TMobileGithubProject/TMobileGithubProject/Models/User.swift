//
//  User.swift
//  TMobileGithubProject
//
//  Created by JerryRen on 1/21/20.
//  Copyright © 2020 JerryRen. All rights reserved.
//

import Foundation

struct User: Decodable {
  let name: String?
  let login: String
  let avatarURL: String?
  let numberOfPublicRepos: Int
  let numberOfFollowers: Int
  let numberFollowing: Int
  let biography: String?
  let location: String?
  let email: String?
  let joinDate: String
  let reposURL: URL
  
  enum CodingKeys: String, CodingKey {
    case name
    case avatarURL = "avatar_url"
    case numberOfPublicRepos = "public_repos"
    case numberOfFollowers = "followers"
    case numberFollowing = "following"
    case biography = "bio"
    case location
    case email
    case joinDate = "created_at"
    case reposURL = "repos_url"
    case login
  }
}
