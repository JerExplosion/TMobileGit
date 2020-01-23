//
//  Session.swift
//  TMobileGithubProject
//
//  Created by JerryRen on 1/21/20.
//  Copyright © 2020 JerryRen. All rights reserved.
//

import Foundation
import UIKit

protocol Session {
  func getModel<T: Decodable>(from url: String, modelType: T.Type, completion: @escaping (Result<T, Error>) -> Void)
}

protocol ImageSession {
  func getImage(from url: String, completion: @escaping (Result<UIImage, Error>) -> Void)
}
