import Foundation
import Alamofire

// MARK: - BitbucketModel
struct BitbucketModel: Codable {
    var values: [Value]
}

// MARK: - Value
struct Value: Codable {
    let name, valueDescription: String
    let owner: BitbucketOwner

    enum CodingKeys: String, CodingKey {
        case name
        case valueDescription = "description"
        case owner
    }
}

// MARK: Value convenience initializers and mutators

extension Value {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Value.self, from: data)
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
        name: String? = nil,
        valueDescription: String? = nil,
        owner: BitbucketOwner? = nil
    ) -> Value {
        return Value(
            name: name ?? self.name,
            valueDescription: valueDescription ?? self.valueDescription,
            owner: owner ?? self.owner
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
struct BitbucketOwner: Codable {
    let displayName: String
    let links: Links
    let type: BitbucketTypeEnum
    let uuid: String
    let accountID, nickname, username: String?

    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case links, type, uuid
        case accountID = "account_id"
        case nickname, username
    }
}

// MARK: Owner convenience initializers and mutators

extension BitbucketOwner {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(BitbucketOwner.self, from: data)
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
        displayName: String? = nil,
        links: Links? = nil,
        type: BitbucketTypeEnum? = nil,
        uuid: String? = nil,
        accountID: String?? = nil,
        nickname: String?? = nil,
        username: String?? = nil
    ) -> BitbucketOwner {
        return BitbucketOwner(
            displayName: displayName ?? self.displayName,
            links: links ?? self.links,
            type: type ?? self.type,
            uuid: uuid ?? self.uuid,
            accountID: accountID ?? self.accountID,
            nickname: nickname ?? self.nickname,
            username: username ?? self.username
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
//   Alamofire.request(url).responseLinks { response in
//     if let links = response.result.value {
//       ...
//     }
//   }

// MARK: - Links
struct Links: Codable {
    let linksSelf, avatar, html: Avatar

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case avatar, html
    }
}

// MARK: Links convenience initializers and mutators

extension Links {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Links.self, from: data)
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
        linksSelf: Avatar? = nil,
        avatar: Avatar? = nil,
        html: Avatar? = nil
    ) -> Links {
        return Links(
            linksSelf: linksSelf ?? self.linksSelf,
            avatar: avatar ?? self.avatar,
            html: html ?? self.html
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
//   Alamofire.request(url).responseAvatar { response in
//     if let avatar = response.result.value {
//       ...
//     }
//   }

// MARK: - Avatar
struct Avatar: Codable {
    let href: String
}

// MARK: Avatar convenience initializers and mutators

extension Avatar {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Avatar.self, from: data)
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
        href: String? = nil
    ) -> Avatar {
        return Avatar(
            href: href ?? self.href
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

enum BitbucketTypeEnum: String, Codable {
    case team = "team"
    case user = "user"
}
