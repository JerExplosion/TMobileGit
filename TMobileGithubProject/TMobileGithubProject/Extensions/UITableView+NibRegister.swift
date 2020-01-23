//
//  UITableView+NibRegister.swift
//  TMobileGithubProject
//
//  Created by JerryRen on 1/22/20.
//  Copyright © 2020 JerryRen. All rights reserved.
//

import UIKit

extension UITableView {
  func registerCell<T: UITableViewCell & NibRegister>(_ cellType: T.Type) {
    let cellNib = UINib(nibName: cellType.nibName,
                        bundle: cellType.bundle)
    self.register(cellNib,
                  forCellReuseIdentifier: cellType.reuseIdentifier)
  }
  
  func dequeueCell<T: UITableViewCell & NibRegister>(_ cellType: T.Type, indexPath: IndexPath) -> T {
    guard let castedCell = self.dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
      fatalError("The cell failed to be casted to the provided type. Make sure you have the cell type registered.")
    }
    return castedCell
  }
}
