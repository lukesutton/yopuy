import Foundation
import Yopuy

enum ConversionError: Error {
case parseFailure(String)
}

struct Post: RootResource, IsRESTFul {
    typealias ID = Int
    typealias Collection = [Post]
    typealias Singular = Post
    static let path = "posts"
    let id: Int


    static func parse(collection data: Data) throws -> Collection {
      let json = try JSONSerialization.jsonObject(with: data) as? [[String: Any]]
      return try json!.map { try Post(json: $0) }
    }

    static func parse(singular data: Data) throws -> Singular {
      let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
      return Post(id: json!["id"] as! Int)
    }
}

extension Post {
    init(json: [String: Any]) throws {
      if let id = json["id"] as? Int {
        self.id = id
      }
      else {
        throw ConversionError.parseFailure("Could not extract ID")
      }
    }
}

struct Comment: ChildResource, IsRESTFul {
    typealias ID = Int
    typealias Parent = Post
    typealias Collection = [Comment]
    typealias Singular = Comment
    static let path = "comments"
    let id: Int

    static func parse(collection data: Data) throws -> Collection {
      return []
    }

    static func parse(singular data: Data) throws -> Singular {
      return Comment(id: 20)
    }
}

struct Commenter: ChildResource, IsShowable, IsListable, IsDeletable {
    typealias ID = Int
    typealias Parent = Comment
    typealias Collection = [Commenter]
    typealias Singular = Commenter
    static let path = "commenter"
    let id: Int

    static func parse(collection data: Data) throws -> Collection {
      return []
    }

    static func parse(singular data: Data) throws -> Singular {
      return Commenter(id: 20)
    }
}

extension Post: Hashable {
  var hashValue: Int {
    return id
  }

  static func ==(lhs: Post, rhs: Post) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
