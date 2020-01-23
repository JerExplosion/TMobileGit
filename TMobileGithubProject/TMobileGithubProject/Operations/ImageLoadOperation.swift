//
//  ImageLoadOperation.swift
//  TMobileGithubProject
//
//  Created by JerryRen on 1/22/20.
//  Copyright © 2020 JerryRen. All rights reserved.
//

import Foundation
import UIKit

final class ImageLoadOperation: Operation {
  
  private let imageSession: ImageSession
  private let imageURL: String
  private var image: UIImage? {
    didSet {
      guard let image = self.image else { return }
      self.imageUpdate?(image)
    }
  }
  
  private var error: Error? {
    didSet {
      guard let error = self.error else { return }
      self.errorClosure?(error)
    }
  }
  
  private var imageUpdate: ((UIImage) -> Void)?
  private var errorClosure: ((Error) -> Void)?
  
  init(imageURL: String, imageSession: ImageSession = NetworkManager.shared) {
    self.imageSession = imageSession
    self.imageURL = imageURL
  }
  
  override func main() {
    guard !self.isCancelled else { return }
    self.imageSession.getImage(from: self.imageURL) { [weak self] result in
      guard self?.isCancelled == false else { return }
      switch result {
      case .failure(let error):
        self?.error = error
      case .success(let image):
        self?.image = image
      }
    }
  }
  
  func update(_ imageUpdate: @escaping (UIImage) -> Void) {
    if let image = self.image {
      imageUpdate(image)
    } else {
      self.imageUpdate = imageUpdate
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
