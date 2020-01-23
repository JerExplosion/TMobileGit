//
//  NetworkManager.swift
//  TMobileGithubProject
//
//  Created by JerryRen on 1/21/20.
//  Copyright © 2020 JerryRen. All rights reserved.
//

import Foundation
import UIKit

final class NetworkManager: Session, ImageSession {
  static let shared = NetworkManager()
  private let authenticationToken = "48fc9315d12a8010b82db7ed763ae82cfd7c35c5"
  private init() { }
  
  func getModel<T: Decodable>(from url: String, modelType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
    guard let generatedURL = URL(string: url) else {
      completion(.failure(NetworkError.invalidURL))
      return
    }
    var request = URLRequest(url: generatedURL)
    request.addValue("token \(self.authenticationToken)", forHTTPHeaderField: "Authorization")
    URLSession.shared.dataTask(with: request) { [unowned self] (data, response, error) in
      do {
        try self.checkForError(error)
        let data = try self.checkForData(data)
        let model = try JSONDecoder().decode(T.self, from: data)
        completion(.success(model))
      } catch {
        completion(.failure(error))
      }
    }.resume()
  }
  
  func getImage(from url: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
    guard let generatedURL = URL(string: url) else {
      completion(.failure(NetworkError.invalidURL))
      return
    }
    URLSession.shared.dataTask(with: generatedURL) { [unowned self] (data, response, error) in
      do {
        try self.checkForError(error)
        let data = try self.checkForData(data)
        let image = try self.checkForValidImage(data)
        completion(.success(image))
      } catch {
        completion(.failure(error))
      }
    }.resume()
  }
  
  private func checkForValidImage(_ data: Data) throws -> UIImage {
    guard let image = UIImage(data: data) else {
      throw NetworkError.badData
    }
    return image
  }
  
  private func checkForError(_ error: Error?) throws {
    guard let error = error else { return }
    throw error
  }
  
  private func checkForData(_ data: Data?) throws -> Data {
    guard let data = data else {
      throw NetworkError.noData
    }
    return data
  }
}
