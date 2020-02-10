//
//  Networking.swift
//  NetworkingExample
//
//  Created by Daniel Koza on 2/10/20.
//  Copyright © 2020 Daniel Koza. All rights reserved.
//

import Foundation

extension NetworkRouterCodable {
    @discardableResult
    func request(completion: @escaping (Result<ModelType, Error>) -> Void) -> URLRequest? {

        do {
            let request = try asURLRequest()
            session.dataTask(with: request) { (responseData, response, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                } else if let responseData = responseData {
                    completion(responseData.serializeModel())
                }
                else {
                    completion(.failure(NetworkingError.invalidRequest))
                }
            }
            return request

        } catch let error {
            completion(.failure(error))
            return nil
        }
    }

    @discardableResult
    func requestCollection(completion: @escaping (Result<[ModelType], Error>) -> Void) -> URLRequest? {
        do {
            let request = try asURLRequest()
            session.dataTask(with: request) { (responseData, response, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                } else if let responseData = responseData {
                    completion(responseData.serializeModels())
                }
                else {
                    completion(.failure(NetworkingError.invalidRequest))
                }
            }
            return request

        } catch let error {
            completion(.failure(error))
            return nil
        }
    }
}
