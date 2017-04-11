# Yopuy

[![Build Status](https://travis-ci.org/lukesutton/yopuy.svg?branch=master)](https://travis-ci.org/lukesutton/yopuy)

An experiment with a simple wrapper for accessing JSON/REST web APIs. Inspired by [an episode](https://talk.objc.io/episodes/S01E01-networking) of Swift Talk.

This library differs in that it allows for nesting of resources — in a type safe manner — with some nice operators to aid in the composition of resources.

Since this is a sketch, there are no tests, no documentation and no introduction. Soz.

## An Example

This is a simple example of how we can encode a type-safe hierarchy of resources. They don't have any properties defined, since they are only demonstrating how parent and child resources are related. The `IsRESTFul` protocol is used to extend the structs with all the HTTP verbs used in a REST API. Also note how the `Commenter` struct is extended by a subset of the protocols available.

```swift
struct Post: RootResource, IsRESTFul {
    typealias ID = Int
    typealias Collection = [Post]
    typealias Singular = Post
    static let path = "posts"
    let id: Int

    static func parse(collection data: Data) throws -> Collection {
      return []
    }

    static func parse(singular data: Data) throws -> Singular {
      return Post(id: 20)
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

let e = Post.show(1) / Comment.show(2) / Commenter.delete(1)
```

There are a few interesting things about the example above:

- Resources are either `RootResource` or `ChildResource` which dictates how they can be used
- Constructing a path like `Post.show(1) / Commenter.show(5)` is a type-error, since `Commenter` has `Comment` as it's parent
- Making `Post` a child is a type error, since it is a `RootResource`
- Constructing a path with a child resource at the root is also a type-error
- It's configured so that a `create` path can't be constructed for the `Commenter` resource
- Paths also encode the HTTP verb
- Parsing is entirely delegated to your code; use whatever parsing library you prefer
- The operations on collections and resources are encoded in separate protocols — e.g. `IsDeletable`, `IsListable` — meaning you can pick and choose what you include
- `IsRESTful` is just a shortcut for including all the `Is*` protocols on a resource
- Declaring a resource without the `IsRESTful` or `Is*` protocols means they're useless, all methods come from optional protocols
- Using typealias means the results of your requests can be arbitrary types e.g. `CustomCollection<Post>`

## Making a request

The request component of Yopuy is designed so that it is un-opinionated about the HTTP library you use. The only requirement is that your HTTP client conforms to the `HTTPAdapter` protocol i.e. it supports `GET`, `POST`, `PUT`, `PATCH` and `DELETE` requests.

```swift
let service = Service(adapter: YourFancyAdapter())
let comment = Post.show(1) / Comment.show(12)
service.call(comment) { result in
  print(result)
}
```
