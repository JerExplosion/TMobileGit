//
//  NibRegister.swift
//  TMobileGithubProject
//
//  Created by JerryRen on 1/22/20.
//  Copyright © 2020 JerryRen. All rights reserved.
//

import Foundation

protocol NibRegister {
  static var bundle: Bundle? { get }
  static var nibName: String { get }
  static var reuseIdentifier: String { get }
}
