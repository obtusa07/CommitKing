//
//  GithubToken.swift
//  CommitKing
//
//  Created by Taehwan Kim on 2023/03/14.
//

import Foundation

struct GithubToken: Codable {
    let accessToken, scope, tokenType: String
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case scope
        case tokenType = "token_type"
    }
}
