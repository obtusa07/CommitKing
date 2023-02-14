//
//  GithubEventConfig.swift
//  CommitKing
//
//  Created by Taehwan Kim on 2023/02/14.
//

import Foundation

struct GithubEventConfigElement: Codable {
    let id: String
    let type: TypeEnum
    let actor: Actor
    let repo: Repo
    let payload: Payload
    let githubEventConfigPublic: Bool
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id, type, actor, repo, payload
        case githubEventConfigPublic = "public"
        case createdAt = "created_at"
    }
}

// MARK: - Actor
struct Actor: Codable {
    let id: Int
    let login, displayLogin: Login
    let gravatarID: String
    let url, avatarURL: String

    enum CodingKeys: String, CodingKey {
        case id, login
        case displayLogin = "display_login"
        case gravatarID = "gravatar_id"
        case url
        case avatarURL = "avatar_url"
    }
}

enum Login: String, Codable {
    case obtusa07 = "obtusa07"
}

// MARK: - Payload
struct Payload: Codable {
    let repositoryID, pushID, size, distinctSize: Int?
    let ref: MasterBranch?
    let head, before: String?
    let commits: [Commit]?
    let refType: String?
    let masterBranch: MasterBranch?
    let description, pusherType, action: String?
    let issue: Issue?

    enum CodingKeys: String, CodingKey {
        case repositoryID = "repository_id"
        case pushID = "push_id"
        case size
        case distinctSize = "distinct_size"
        case ref, head, before, commits
        case refType = "ref_type"
        case masterBranch = "master_branch"
        case description
        case pusherType = "pusher_type"
        case action, issue
    }
}

// MARK: - Commit
struct Commit: Codable {
    let sha: String
    let author: Author
    let message: String
    let distinct: Bool
    let url: String
}

// MARK: - Author
struct Author: Codable {
    let email: Email
    let name: AuthorName
}

enum Email: String, Codable {
    case obtusa07GmailCOM = "obtusa07@gmail.com"
    case the47441965Obtusa07UsersNoreplyGithubCOM = "47441965+obtusa07@users.noreply.github.com"
}

enum AuthorName: String, Codable {
    case taehwanKim = "Taehwan Kim"
    case taehwanKimKen = "Taehwan Kim (Ken)"
}

// MARK: - Issue
struct Issue: Codable {
    let url, repositoryURL: String
    let labelsURL: String
    let commentsURL, eventsURL, htmlURL: String
    let id: Int
    let nodeID: String
    let number: Int
    let title: String
    let user: User
    let labels: [Label]
    let state: String
    let locked: Bool
    let assignee: JSONNull?
    let assignees: [JSONAny]
    let milestone: JSONNull?
    let comments: Int
    let createdAt, updatedAt: Date
    let closedAt: JSONNull?
    let authorAssociation: String
    let activeLockReason, body: JSONNull?
    let reactions: Reactions
    let timelineURL: String
    let performedViaGithubApp, stateReason: JSONNull?

    enum CodingKeys: String, CodingKey {
        case url
        case repositoryURL = "repository_url"
        case labelsURL = "labels_url"
        case commentsURL = "comments_url"
        case eventsURL = "events_url"
        case htmlURL = "html_url"
        case id
        case nodeID = "node_id"
        case number, title, user, labels, state, locked, assignee, assignees, milestone, comments
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case closedAt = "closed_at"
        case authorAssociation = "author_association"
        case activeLockReason = "active_lock_reason"
        case body, reactions
        case timelineURL = "timeline_url"
        case performedViaGithubApp = "performed_via_github_app"
        case stateReason = "state_reason"
    }
}

// MARK: - Label
struct Label: Codable {
    let id: Int
    let nodeID: String
    let url: String
    let name, color: String
    let labelDefault: Bool
    let description: String

    enum CodingKeys: String, CodingKey {
        case id
        case nodeID = "node_id"
        case url, name, color
        case labelDefault = "default"
        case description
    }
}

// MARK: - Reactions
struct Reactions: Codable {
    let url: String
    let totalCount, the1, reactions1, laugh: Int
    let hooray, confused, heart, rocket: Int
    let eyes: Int

    enum CodingKeys: String, CodingKey {
        case url
        case totalCount = "total_count"
        case the1 = "+1"
        case reactions1 = "-1"
        case laugh, hooray, confused, heart, rocket, eyes
    }
}

// MARK: - User
struct User: Codable {
    let login: Login
    let id: Int
    let nodeID: String
    let avatarURL: String
    let gravatarID: String
    let url, htmlURL, followersURL: String
    let followingURL, gistsURL, starredURL: String
    let subscriptionsURL, organizationsURL, reposURL: String
    let eventsURL: String
    let receivedEventsURL: String
    let type: String
    let siteAdmin: Bool

    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case url
        case htmlURL = "html_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case gistsURL = "gists_url"
        case starredURL = "starred_url"
        case subscriptionsURL = "subscriptions_url"
        case organizationsURL = "organizations_url"
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case receivedEventsURL = "received_events_url"
        case type
        case siteAdmin = "site_admin"
    }
}

enum MasterBranch: String, Codable {
    case main = "main"
    case refsHeadsMain = "refs/heads/main"
}

// MARK: - Repo
struct Repo: Codable {
    let id: Int
    let name: RepoName
    let url: String
}

enum RepoName: String, Codable {
    case obtusa07Algorithm = "obtusa07/algorithm"
    case obtusa07CommitKing = "obtusa07/CommitKing"
    case obtusa07GithubPractice = "obtusa07/githubPractice"
    case obtusa07IOSInterview = "obtusa07/iOSInterview"
}

enum TypeEnum: String, Codable {
    case createEvent = "CreateEvent"
    case issuesEvent = "IssuesEvent"
    case pushEvent = "PushEvent"
}

typealias GithubEventConfig = [GithubEventConfigElement]
