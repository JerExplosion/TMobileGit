//
//  Repository.swift
//  TMobileGithubProject
//
//  Created by JerryRen on 1/21/20.
//  Copyright © 2020 JerryRen. All rights reserved.
//

import Foundation

struct Repository: Decodable {
  let name: String
  let forks: Int
  let stars: Int
  let htmlURL: URL
  
  enum CodingKeys: String, CodingKey {
    case name
    case forks
    case stars = "stargazers_count"
    case htmlURL = "html_url"
  }
}
