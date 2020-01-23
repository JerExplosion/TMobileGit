//
//  RepositoryResponse.swift
//  TMobileGithubProject
//
//  Created by JerryRen on 1/22/20.
//  Copyright © 2020 JerryRen. All rights reserved.
//

import Foundation

struct RepositoryResponse: Decodable {
  let items: [Repository]
}
