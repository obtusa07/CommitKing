//
//  GithubConstants.swift
//  githubPractice
//
//  Created by Taehwan Kim on 2023/02/04.
//

import Foundation

struct GithubConstants {
    static let CLIENT_ID = "Iv1.dfacac4ef8c2445f"
    static let CLIENT_SECRET = "f030fd507b30e7b05df1ebcdd4f762afaeba2aaa"
    static let REDIRECT_URI = "https://127.0.0.1:8080/login/github/callback"
    // 리다이렉트는 확실하지 않음
    static let SCOPE = "read:user,user:email"
    static let TOKENURL = "https://github.com/login/oauth/access_token"
    
}
