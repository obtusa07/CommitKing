//
//  GithubConstants.swift
//  githubPractice
//
//  Created by Taehwan Kim on 2023/02/05.
//

import Foundation

struct GithubConfig {
    static let CLIENT_ID = "5c3be7a0aa405a2a10ea"
    static let CLIENT_SECRET = "0faccf62b282c72ad65dda0f98452d3203347a24"
    static let REDIRECT_URI_LOGIN = "githubPractice://login"
    static let SCOPE = "read:user,user:email"
    static let CODEURL = "https://github.com/login/oauth/authorize"
    static let TOKENURL = "https://github.com/login/oauth/access_token"
}

struct GithubTokenParser: Codable {
    let accessToken, scope, tokenType: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case scope
        case tokenType = "token_type"
    }
}
