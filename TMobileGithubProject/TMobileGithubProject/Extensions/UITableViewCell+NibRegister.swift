//
//  UITableViewCell+NibRegister.swift
//  TMobileGithubProject
//
//  Created by JerryRen on 1/22/20.
//  Copyright © 2020 JerryRen. All rights reserved.
//

import UIKit

extension NibRegister where Self: UITableViewCell {
  static var bundle: Bundle? {
    return nil
  }
  
  static var nibName: String {
    return String(describing: self)
  }
  
  static var reuseIdentifier: String {
    return String(describing: self)
  }
}
