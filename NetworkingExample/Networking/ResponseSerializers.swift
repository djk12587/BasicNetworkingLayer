//
//  ResponseSerializers.swift
//  NetworkingExample
//
//  Created by Daniel Koza on 2/10/20.
//  Copyright © 2020 Daniel Koza. All rights reserved.
//

import Foundation

/// This allows you to decode an array of objects and remove the models that are invalid instead of invalidating the entire array
private struct FailableDecodable<T: Decodable>: Decodable {

    let value: T?

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.value = try? container.decode(T.self)
    }
}

extension Data {
    func serializeModels<ModelType: Decodable>() -> Swift.Result<[ModelType], Error> {
        do {
            let failableDecodedModels = try JSONDecoder().decode([FailableDecodable<ModelType>].self, from: self)
            return .success(failableDecodedModels.compactMap { $0.value })
        }
        catch {
            return .failure(error)
        }
    }

    func serializeModel<ModelType: Decodable>() -> Swift.Result<ModelType, Error> {
        do {
            return .success(try JSONDecoder().decode(ModelType.self, from: self))
        }
        catch {
            return .failure(error)
        }
    }
}


