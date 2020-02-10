//
//  Router.swift
//  NetworkingExample
//
//  Created by Daniel Koza on 2/10/20.
//  Copyright © 2020 Daniel Koza. All rights reserved.
//

import Foundation

enum NetworkEncoding {
    case json, url
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkingError: Error {
    case badUrl
    case jsonEncodingFailed
    case invalidRequest
}

protocol URLRequestConvertible {
    func asURLRequest() throws -> URLRequest
}

protocol NetworkRouter: URLRequestConvertible {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var encoding: NetworkEncoding { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
    var session: URLSession { get }
}

protocol NetworkRouterCodable: NetworkRouter {
    associatedtype ModelType: Decodable
}

extension NetworkRouter {

    var parameters: [String : Any]? { return nil }
    var headers: [String: String]? { return nil }

    func asURLRequest() throws -> URLRequest {
        guard let url = Foundation.URL(string: baseURL)?.appendingPathComponent(path) else {
            throw NetworkingError.badUrl
        }

        var mutableRequest = URLRequest(url: url)
        mutableRequest.httpMethod = method.rawValue

        switch encoding {
            case .json:
                mutableRequest = try JSONEncoding.encode(mutableRequest, with: parameters)
            case .url:
                print("do something similar for other types of encoding")
//                mutableRequest = try URLEncoding.default.encode(mutableRequest, with: parameters)
        }

        headers?.forEach { mutableRequest.addValue($0.value, forHTTPHeaderField: $0.key) }

        return mutableRequest
    }
}

/// This was stolen from Alamofire
private enum JSONEncoding {
    static func encode(_ urlRequest: URLRequest, with parameters: [String: Any]?) throws -> URLRequest {
        var urlRequest = urlRequest

        guard let parameters = parameters else { return urlRequest }

        do {
            let data = try JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed)

            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }

            urlRequest.httpBody = data
        } catch {
            throw NetworkingError.jsonEncodingFailed
        }

        return urlRequest
    }
}

