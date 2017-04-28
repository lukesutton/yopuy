![](https://cdn.rawgit.com/lukesutton/yopuy/master/logo.svg)

# Yopuy - Type-safe glue for REST APIs

[![Build Status](https://travis-ci.org/lukesutton/yopuy.svg?branch=master)](https://travis-ci.org/lukesutton/yopuy)

An experiment with a simple wrapper for accessing JSON/REST web APIs. Inspired by [an episode](https://talk.objc.io/episodes/S01E01-networking) of Swift Talk.

The main aims for this library are:

- Type-safety where appropriate
- Encoding/decoding agnostic
- HTTP client agnostic

Here is an example of it in use.

```swift
let service = Service(adapter: YourFancyAdapter(), URL: url)
let comment = Post.show(1) / Comment.show(12)

service.call(comment) { result in
  print(result)
}
```

## Resources

Yopuy handles the interaction with an API via types which conform to the `Resource` protocol. The `Resource` protocol, various `associatedtype` declarations and other related protocols — e.g. `ChildResource`, `RootResource` — are used to grant capabilities to these types. Generally these are static functions and properties which return values representing full or partial paths to a resource.

For example, a `RootResource` is one that has a path that exists at the root of an API. This adds a number of constraints.

- It cannot belong to a parent resource
- Any path it generates will be at the root of the API

A corresponding protocol is `ChildResource`. It has an `associatedtype Parent` requirement. This associates a child resource with it's parent. It then guides the type-safe construction of paths e.g. `Post.show(1) / Comment.show(12)`

## Fine-Grained Capabilities

By default a `Resource` lacks any of the path static functions or properties. These are provided by conforming to protocols. Most of the protocols correspond to a HTTP method.

- `IsListable`; can be retrieved as a collection e.g. `GET /posts`
- `IsShowable`; can be retrieved as a single record e.g. `GET /posts/1`
- `IsCreatable`; new resources can be created e.g. `POST /posts`
- `IsReplaceable`; a resource can be updated via `PUT` e.g. `PUT /posts/1`
- `IsPatchable`; a resource can be updated via `PATCH` e.g. `PATCH /posts/1`
- `IsDeletable`; a resource can be deleted via `DELETE` e.g. `DELETE /posts/1`

Here is an example of a record that can be updated, but not created or deleted.

```swift
struct Foo: RootResource, IsPatchable, IsShowable {
  // Details elided...
}
```

## A Longer Example

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
