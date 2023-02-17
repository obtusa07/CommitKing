//
//  GithubCommitsConfig.swift
//  CommitKing
//
//  Created by Taehwan Kim on 2023/02/14.
//

import Foundation

struct GithubCommitsConfig: Codable {
    let totalCount: Int
    let items: [Item]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items
    }
}

// MARK: - Item
struct Item: Codable {
    let url: String
    let sha, nodeID: String
    let htmlURL, commentsURL: String
    let commit: Commit
    let score: Int

    enum CodingKeys: String, CodingKey {
        case url, sha
        case nodeID = "node_id"
        case htmlURL = "html_url"
        case commentsURL = "comments_url"
        case commit, score
    }
}

// MARK: - Commit
struct Commit: Codable {
    let url: String
    let author, committer: CommitAuthor
    let message: String
    let commentCount: Int

    enum CodingKeys: String, CodingKey {
        case url, author, committer, message
        case commentCount = "comment_count"
    }
}

// MARK: - CommitAuthor
struct CommitAuthor: Codable {
    let date, name, email: String
}
