//
//  API.swift
//  NetworkingExample
//
//  Created by Daniel Koza on 2/10/20.
//  Copyright © 2020 Daniel Koza. All rights reserved.
//

import Foundation

enum API {
    enum SomeAPISource {}
}

protocol SomeAPISourceRouter: NetworkRouterCodable {
    var clientId: String { get }
    var grantType: String { get }
    var clientSecret: String { get }
    var baseURL: String { get }
}

extension SomeAPISourceRouter {

    var grantType: String {
        return "client_credentials"
    }

    var clientId: String {
        // This is the same Id for staging and prod...
        return "someId"
    }

    var clientSecret: String {
        // This is the same secret for staging and prod...
        return "someSecret"
    }

    var baseURL: String {
        #if DEV
            return "devBaseUrl"
        #elseif STAGE
            return "stagingBaseUrl"
        #else
            return "prodBaseUrl"
        #endif
    }

    //Configure a specific URLSession if required
    var session: URLSession { return URLSession.shared }
}

extension API.SomeAPISource {

    struct GetAccessTokenExample: SomeAPISourceRouter {
        typealias ModelType = Models.AccessToken

        var path: String { return "/getSomeAccessToken" }
        var method: HTTPMethod { return .get }
        var encoding: NetworkEncoding { return .json }

        var parameters: [String : Any]? {
            return ["client_id" : clientId,
                    "client_secret" : clientSecret]
        }
    }

    struct RequestVerificationUrl: SomeAPISourceRouter {
        typealias ModelType = Models.VerificationAccess

        var aRequestParameter: String
        var accessToken: String

        var path: String { return "/postSomData" }
        var method: HTTPMethod { return .post }
        var encoding: NetworkEncoding { return .json }

        var parameters: [String : Any]? {
            return ["postParam" : aRequestParameter]
        }

        var headers: [String : String]? {
            return ["Authorization" : "Bearer \(accessToken)"]
        }
    }
}
