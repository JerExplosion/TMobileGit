//
//  UserResponse.swift
//  TMobileGithubProject
//
//  Created by JerryRen on 1/21/20.
//  Copyright © 2020 JerryRen. All rights reserved.
//

import Foundation

struct UserResponse: Decodable {
  let items: [SpecificUserResponse]
}
