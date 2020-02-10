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
                    DispatchQueue.main.async { completion(.failure(error)) }
                    return
                } else if let responseData = responseData {
                    let serializedResponse: Result<ModelType, Error> = responseData.serializeModel()
                    DispatchQueue.main.async { completion(serializedResponse) }
                }
                else {
                    DispatchQueue.main.async { completion(.failure(NetworkingError.invalidRequest)) }
                }
            }
            return request

        } catch let error {
            DispatchQueue.main.async { completion(.failure(error)) }
            return nil
        }
    }

    @discardableResult
    func requestCollection(completion: @escaping (Result<[ModelType], Error>) -> Void) -> URLRequest? {
        do {
            let request = try asURLRequest()
            session.dataTask(with: request) { (responseData, response, error) in
                if let error = error {
                    DispatchQueue.main.async { completion(.failure(error)) }
                    return
                } else if let responseData = responseData {
                    let serializedResponse: Result<[ModelType], Error> = responseData.serializeModels()
                    DispatchQueue.main.async { completion(serializedResponse) }
                }
                else {
                    DispatchQueue.main.async { completion(.failure(NetworkingError.invalidRequest)) }
                }
            }
            return request

        } catch let error {
            DispatchQueue.main.async { completion(.failure(error)) }
            return nil
        }
    }
}
