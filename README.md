# Yopuy

An experiment with a simple wrapper for accessing JSON/REST web APIs. Inspired by [an episode](https://talk.objc.io/episodes/S01E01-networking) of Swift Talk.

This library differs in that it allows for nesting of resources — in a type safe manner — with some nice operators to aid in the composition of resources.

Since this is a sketch, there are no tests, no documentation and no introduction. Soz.

## An Example

This is a simple example of how we can encode a type-safe hierarchy of resources. They don't have any properties defined, since they are only demonstrating how parent and child resources are related. The `IsRESTFul` protocol is used to extend the structs with all the HTTP verbs used in a REST API. Also note how the `Commenter` struct is extended by a subset of the protocols available.

```swift
struct Post: RootResource, IsRESTFul {
    typealias IDType = Int
    static let path = "posts"
    init(json: [String: Any]) {

    }
}

struct Comment: ChildResource, IsRESTFul {
    typealias IDType = Int
    typealias Parent = Post
    static let path = "comments"
    init(json: [String: Any]) {

    }
}

struct Commenter: ChildResource, IsShowable, IsListable, IsDeletable {
    typealias IDType = Int
    typealias Parent = Comment
    static let path = "commenter"
    init(json: [String: Any]) {

    }
}

let e = Post.show(1) / Comment.show(2) / Commenter.delete(1)
```
