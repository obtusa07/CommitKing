//
//  GithubConfig.swift
//  CommitKing
//
//  Created by Taehwan Kim on 2023/02/11.
//

import Foundation

struct GithubConfig {
    static let CLIENT_ID = "ee5877eb315e1524abda"
    static let CLIENT_SECRET = "4a0f37a176e03e96339f8f8ab70db839426c923a"
    static let REDIRECT_URI_LOGIN = "CommitKing://login"
    static let SCOPE = "read:user,user:email"
    static let CODEURL = "https://github.com/login/oauth/authorize"
    static let TOKENURL = "https://github.com/login/oauth/access_token"
    static let COMMITURL = "https://api.github.com/search/commits"
}

struct GithubToken: Codable {
    let accessToken, scope, tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case scope
        case tokenType = "token_type"
    }
}

struct GithubUrls {
    static let MYINFO = "https://api.github.com/user"
}


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

//struct UserRepo: Codable {
//    let id: Int
//    let nodeID, name, fullName: String
//    let userRepoPrivate: Bool
//    let htmlURL: String
//    let description: String?
//    let fork: Bool
//    let url: String
//    let forksURL: String
//    let keysURL, collaboratorsURL: String
//    let teamsURL, hooksURL: String
//    let issueEventsURL: String
//    let eventsURL: String
//    let assigneesURL, branchesURL: String
//    let tagsURL: String
//    let blobsURL, gitTagsURL, gitRefsURL, treesURL: String
//    let statusesURL: String
//    let languagesURL, stargazersURL, contributorsURL, subscribersURL: String
//    let subscriptionURL: String
//    let commitsURL, gitCommitsURL, commentsURL, issueCommentURL: String
//    let contentsURL, compareURL: String
//    let mergesURL: String
//    let archiveURL: String
//    let downloadsURL: String
//    let issuesURL, pullsURL, milestonesURL, notificationsURL: String
//    let labelsURL, releasesURL: String
//    let deploymentsURL: String
//    let createdAt, updatedAt, pushedAt: Date
//    let gitURL, sshURL: String
//    let cloneURL: String
//    let svnURL: String
//    let homepage: String?
//    let size, stargazersCount, watchersCount: Int
//    let language: Language?
//    let hasIssues, hasProjects, hasDownloads, hasWiki: Bool
//    let hasPages, hasDiscussions: Bool
//    let forksCount: Int
//    let mirrorURL: JSONNull?
//    let archived, disabled: Bool
//    let openIssuesCount: Int
//    let license: JSONNull?
//    let allowForking, isTemplate, webCommitSignoffRequired: Bool
//    let topics: [JSONAny]
//    let visibility: Visibility
//    let forks, openIssues, watchers: Int
//    let defaultBranch: DefaultBranch
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case nodeID = "node_id"
//        case name
//        case fullName = "full_name"
//        case userRepoPrivate = "private"
//        case owner
//        case htmlURL = "html_url"
//        case description, fork, url
//        case forksURL = "forks_url"
//        case keysURL = "keys_url"
//        case collaboratorsURL = "collaborators_url"
//        case teamsURL = "teams_url"
//        case hooksURL = "hooks_url"
//        case issueEventsURL = "issue_events_url"
//        case eventsURL = "events_url"
//        case assigneesURL = "assignees_url"
//        case branchesURL = "branches_url"
//        case tagsURL = "tags_url"
//        case blobsURL = "blobs_url"
//        case gitTagsURL = "git_tags_url"
//        case gitRefsURL = "git_refs_url"
//        case treesURL = "trees_url"
//        case statusesURL = "statuses_url"
//        case languagesURL = "languages_url"
//        case stargazersURL = "stargazers_url"
//        case contributorsURL = "contributors_url"
//        case subscribersURL = "subscribers_url"
//        case subscriptionURL = "subscription_url"
//        case commitsURL = "commits_url"
//        case gitCommitsURL = "git_commits_url"
//        case commentsURL = "comments_url"
//        case issueCommentURL = "issue_comment_url"
//        case contentsURL = "contents_url"
//        case compareURL = "compare_url"
//        case mergesURL = "merges_url"
//        case archiveURL = "archive_url"
//        case downloadsURL = "downloads_url"
//        case issuesURL = "issues_url"
//        case pullsURL = "pulls_url"
//        case milestonesURL = "milestones_url"
//        case notificationsURL = "notifications_url"
//        case labelsURL = "labels_url"
//        case releasesURL = "releases_url"
//        case deploymentsURL = "deployments_url"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case pushedAt = "pushed_at"
//        case gitURL = "git_url"
//        case sshURL = "ssh_url"
//        case cloneURL = "clone_url"
//        case svnURL = "svn_url"
//        case homepage, size
//        case stargazersCount = "stargazers_count"
//        case watchersCount = "watchers_count"
//        case language
//        case hasIssues = "has_issues"
//        case hasProjects = "has_projects"
//        case hasDownloads = "has_downloads"
//        case hasWiki = "has_wiki"
//        case hasPages = "has_pages"
//        case hasDiscussions = "has_discussions"
//        case forksCount = "forks_count"
//        case mirrorURL = "mirror_url"
//        case archived, disabled
//        case openIssuesCount = "open_issues_count"
//        case license
//        case allowForking = "allow_forking"
//        case isTemplate = "is_template"
//        case webCommitSignoffRequired = "web_commit_signoff_required"
//        case topics, visibility, forks
//        case openIssues = "open_issues"
//        case watchers
//        case defaultBranch = "default_branch"
//    }
//}
//
//enum DefaultBranch: String, Codable {
//    case main = "main"
//    case master = "master"
//}
//
//enum Language: String, Codable {
//    case html = "HTML"
//    case python = "Python"
//    case swift = "Swift"
//}
//
//
//enum EventsURL: String, Codable {
//    case httpsAPIGithubCOMUsersObtusa07EventsPrivacy = "https://api.github.com/users/obtusa07/events{/privacy}"
//}
//
//enum FollowingURL: String, Codable {
//    case httpsAPIGithubCOMUsersObtusa07FollowingOtherUser = "https://api.github.com/users/obtusa07/following{/other_user}"
//}
//
//enum GistsURL: String, Codable {
//    case httpsAPIGithubCOMUsersObtusa07GistsGistID = "https://api.github.com/users/obtusa07/gists{/gist_id}"
//}
//
//enum Login: String, Codable {
//    case obtusa07 = "obtusa07"
//}
//
//enum NodeID: String, Codable {
//    case mdq6VXNlcjQ3NDQxOTY1 = "MDQ6VXNlcjQ3NDQxOTY1"
//}
//
//enum StarredURL: String, Codable {
//    case httpsAPIGithubCOMUsersObtusa07StarredOwnerRepo = "https://api.github.com/users/obtusa07/starred{/owner}{/repo}"
//}
//
//enum TypeEnum: String, Codable {
//    case user = "User"
//}
//
//enum Visibility: String, Codable {
//    case visibilityPublic = "public"
//}
//
//typealias UserRepos = [UserRepo]
