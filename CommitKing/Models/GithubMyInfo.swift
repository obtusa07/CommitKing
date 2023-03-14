//
//  GithubMyInfo.swift
//  CommitKing
//
//  Created by Taehwan Kim on 2023/03/14.
//

import Foundation

struct GithubMyInfo: Codable {
    let avatarURL: String?
    let gravatarID: String?
    let url, htmlURL, followersURL, followingURL: String?
    let name, company: String?
    let location, email: String?
    let bio, twitterUsername: String?
    let publicRepos, publicGists, followers, following: Int?
    let privateGists, totalPrivateRepos, ownedPrivateRepos, diskUsage: Int?
    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case url
        case htmlURL = "html_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case name
        case company
        case location
        case email
        case bio
        case twitterUsername = "twitter_username"
        case publicRepos = "public_repos"
        case publicGists = "public_gists"
        case followers
        case following
        case privateGists = "private_gists"
        case totalPrivateRepos = "total_private_repos"
        case ownedPrivateRepos = "owned_private_repos"
        case diskUsage = "disk_usage"
    }
}
