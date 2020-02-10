//
//  SampleModel.swift
//  NetworkingExample
//
//  Created by Daniel Koza on 2/10/20.
//  Copyright © 2020 Daniel Koza. All rights reserved.
//

import Foundation

enum Models {}

extension Models {
    struct AccessToken {
        var token: String
        var tokenType: String

        enum CodingKeys: String, CodingKey {
            case token = "access_token"
            case tokenType = "token_type"
        }
    }
}

extension Models.AccessToken: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        token = try container.decode(String.self, forKey: .token)
        tokenType = (try? container.decode(String.self, forKey: .tokenType)) ?? ""
    }
}

extension Models {
    struct VerificationAccess {
        var url: URL

        enum CodingKeys: String, CodingKey {
            case url = "verifyUrl"
        }
    }
}

extension Models.VerificationAccess: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decode(URL.self, forKey: .url)
    }
}
