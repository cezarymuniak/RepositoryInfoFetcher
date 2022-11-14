import Foundation
import Alamofire

// MARK: - GithubModelElement
struct GithubModelElement: Codable {
    let id: Int
    let nodeID, name, fullName: String
    let githubModelPrivate: Bool
    let owner: Owner
    let htmlURL: String
    let githubModelDescription: String?
    let fork: Bool
    let url, forksURL: String
    let keysURL, collaboratorsURL: String
    let teamsURL, hooksURL: String
    let issueEventsURL: String
    let eventsURL: String
    let assigneesURL, branchesURL: String
    let tagsURL: String
    let blobsURL, gitTagsURL, gitRefsURL, treesURL: String
    let statusesURL: String
    let languagesURL, stargazersURL, contributorsURL, subscribersURL: String
    let subscriptionURL: String
    let commitsURL, gitCommitsURL, commentsURL, issueCommentURL: String
    let contentsURL, compareURL: String
    let mergesURL: String
    let archiveURL: String
    let downloadsURL: String
    let issuesURL, pullsURL, milestonesURL, notificationsURL: String
    let labelsURL, releasesURL: String
    let deploymentsURL: String

    enum CodingKeys: String, CodingKey {
        case id
        case nodeID = "node_id"
        case name
        case fullName = "full_name"
        case githubModelPrivate = "private"
        case owner
        case htmlURL = "html_url"
        case githubModelDescription = "description"
        case fork, url
        case forksURL = "forks_url"
        case keysURL = "keys_url"
        case collaboratorsURL = "collaborators_url"
        case teamsURL = "teams_url"
        case hooksURL = "hooks_url"
        case issueEventsURL = "issue_events_url"
        case eventsURL = "events_url"
        case assigneesURL = "assignees_url"
        case branchesURL = "branches_url"
        case tagsURL = "tags_url"
        case blobsURL = "blobs_url"
        case gitTagsURL = "git_tags_url"
        case gitRefsURL = "git_refs_url"
        case treesURL = "trees_url"
        case statusesURL = "statuses_url"
        case languagesURL = "languages_url"
        case stargazersURL = "stargazers_url"
        case contributorsURL = "contributors_url"
        case subscribersURL = "subscribers_url"
        case subscriptionURL = "subscription_url"
        case commitsURL = "commits_url"
        case gitCommitsURL = "git_commits_url"
        case commentsURL = "comments_url"
        case issueCommentURL = "issue_comment_url"
        case contentsURL = "contents_url"
        case compareURL = "compare_url"
        case mergesURL = "merges_url"
        case archiveURL = "archive_url"
        case downloadsURL = "downloads_url"
        case issuesURL = "issues_url"
        case pullsURL = "pulls_url"
        case milestonesURL = "milestones_url"
        case notificationsURL = "notifications_url"
        case labelsURL = "labels_url"
        case releasesURL = "releases_url"
        case deploymentsURL = "deployments_url"
    }
}

// MARK: GithubModelElement convenience initializers and mutators

extension GithubModelElement {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(GithubModelElement.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        id: Int? = nil,
        nodeID: String? = nil,
        name: String? = nil,
        fullName: String? = nil,
        githubModelPrivate: Bool? = nil,
        owner: Owner? = nil,
        htmlURL: String? = nil,
        githubModelDescription: String?? = nil,
        fork: Bool? = nil,
        url: String? = nil,
        forksURL: String? = nil,
        keysURL: String? = nil,
        collaboratorsURL: String? = nil,
        teamsURL: String? = nil,
        hooksURL: String? = nil,
        issueEventsURL: String? = nil,
        eventsURL: String? = nil,
        assigneesURL: String? = nil,
        branchesURL: String? = nil,
        tagsURL: String? = nil,
        blobsURL: String? = nil,
        gitTagsURL: String? = nil,
        gitRefsURL: String? = nil,
        treesURL: String? = nil,
        statusesURL: String? = nil,
        languagesURL: String? = nil,
        stargazersURL: String? = nil,
        contributorsURL: String? = nil,
        subscribersURL: String? = nil,
        subscriptionURL: String? = nil,
        commitsURL: String? = nil,
        gitCommitsURL: String? = nil,
        commentsURL: String? = nil,
        issueCommentURL: String? = nil,
        contentsURL: String? = nil,
        compareURL: String? = nil,
        mergesURL: String? = nil,
        archiveURL: String? = nil,
        downloadsURL: String? = nil,
        issuesURL: String? = nil,
        pullsURL: String? = nil,
        milestonesURL: String? = nil,
        notificationsURL: String? = nil,
        labelsURL: String? = nil,
        releasesURL: String? = nil,
        deploymentsURL: String? = nil
    ) -> GithubModelElement {
        return GithubModelElement(
            id: id ?? self.id,
            nodeID: nodeID ?? self.nodeID,
            name: name ?? self.name,
            fullName: fullName ?? self.fullName,
            githubModelPrivate: githubModelPrivate ?? self.githubModelPrivate,
            owner: owner ?? self.owner,
            htmlURL: htmlURL ?? self.htmlURL,
            githubModelDescription: githubModelDescription ?? self.githubModelDescription,
            fork: fork ?? self.fork,
            url: url ?? self.url,
            forksURL: forksURL ?? self.forksURL,
            keysURL: keysURL ?? self.keysURL,
            collaboratorsURL: collaboratorsURL ?? self.collaboratorsURL,
            teamsURL: teamsURL ?? self.teamsURL,
            hooksURL: hooksURL ?? self.hooksURL,
            issueEventsURL: issueEventsURL ?? self.issueEventsURL,
            eventsURL: eventsURL ?? self.eventsURL,
            assigneesURL: assigneesURL ?? self.assigneesURL,
            branchesURL: branchesURL ?? self.branchesURL,
            tagsURL: tagsURL ?? self.tagsURL,
            blobsURL: blobsURL ?? self.blobsURL,
            gitTagsURL: gitTagsURL ?? self.gitTagsURL,
            gitRefsURL: gitRefsURL ?? self.gitRefsURL,
            treesURL: treesURL ?? self.treesURL,
            statusesURL: statusesURL ?? self.statusesURL,
            languagesURL: languagesURL ?? self.languagesURL,
            stargazersURL: stargazersURL ?? self.stargazersURL,
            contributorsURL: contributorsURL ?? self.contributorsURL,
            subscribersURL: subscribersURL ?? self.subscribersURL,
            subscriptionURL: subscriptionURL ?? self.subscriptionURL,
            commitsURL: commitsURL ?? self.commitsURL,
            gitCommitsURL: gitCommitsURL ?? self.gitCommitsURL,
            commentsURL: commentsURL ?? self.commentsURL,
            issueCommentURL: issueCommentURL ?? self.issueCommentURL,
            contentsURL: contentsURL ?? self.contentsURL,
            compareURL: compareURL ?? self.compareURL,
            mergesURL: mergesURL ?? self.mergesURL,
            archiveURL: archiveURL ?? self.archiveURL,
            downloadsURL: downloadsURL ?? self.downloadsURL,
            issuesURL: issuesURL ?? self.issuesURL,
            pullsURL: pullsURL ?? self.pullsURL,
            milestonesURL: milestonesURL ?? self.milestonesURL,
            notificationsURL: notificationsURL ?? self.notificationsURL,
            labelsURL: labelsURL ?? self.labelsURL,
            releasesURL: releasesURL ?? self.releasesURL,
            deploymentsURL: deploymentsURL ?? self.deploymentsURL
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseOwner { response in
//     if let owner = response.result.value {
//       ...
//     }
//   }

// MARK: - Owner
struct Owner: Codable {
    let login: String
    let id: Int
    let nodeID: String
    let avatarURL: String
    let gravatarID: String
    let url, htmlURL, followersURL: String
    let followingURL, gistsURL, starredURL: String
    let subscriptionsURL, organizationsURL, reposURL: String
    let eventsURL: String
    let receivedEventsURL: String
    let type: TypeEnum
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

// MARK: Owner convenience initializers and mutators

extension Owner {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Owner.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        login: String? = nil,
        id: Int? = nil,
        nodeID: String? = nil,
        avatarURL: String? = nil,
        gravatarID: String? = nil,
        url: String? = nil,
        htmlURL: String? = nil,
        followersURL: String? = nil,
        followingURL: String? = nil,
        gistsURL: String? = nil,
        starredURL: String? = nil,
        subscriptionsURL: String? = nil,
        organizationsURL: String? = nil,
        reposURL: String? = nil,
        eventsURL: String? = nil,
        receivedEventsURL: String? = nil,
        type: TypeEnum? = nil,
        siteAdmin: Bool? = nil
    ) -> Owner {
        return Owner(
            login: login ?? self.login,
            id: id ?? self.id,
            nodeID: nodeID ?? self.nodeID,
            avatarURL: avatarURL ?? self.avatarURL,
            gravatarID: gravatarID ?? self.gravatarID,
            url: url ?? self.url,
            htmlURL: htmlURL ?? self.htmlURL,
            followersURL: followersURL ?? self.followersURL,
            followingURL: followingURL ?? self.followingURL,
            gistsURL: gistsURL ?? self.gistsURL,
            starredURL: starredURL ?? self.starredURL,
            subscriptionsURL: subscriptionsURL ?? self.subscriptionsURL,
            organizationsURL: organizationsURL ?? self.organizationsURL,
            reposURL: reposURL ?? self.reposURL,
            eventsURL: eventsURL ?? self.eventsURL,
            receivedEventsURL: receivedEventsURL ?? self.receivedEventsURL,
            type: type ?? self.type,
            siteAdmin: siteAdmin ?? self.siteAdmin
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

enum TypeEnum: String, Codable {
    case organization = "Organization"
    case user = "User"
}

typealias GithubModel = [GithubModelElement]

extension Array where Element == GithubModel.Element {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(GithubModel.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
