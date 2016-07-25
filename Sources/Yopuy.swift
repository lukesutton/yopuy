import Foundation

typealias JSONDictionary = [String: AnyObject]

enum Response<E> {
    case parseError(ErrorType)
    case serverError(ErrorType)
    case success(E)
}

protocol Resource {
    associatedtype Result

    var path: String { get }
    var parse: (NSData) -> Result? { get }
}

struct RootResource<Entity>: Resource {
    typealias Result = Entity
    let path: String
    let parse: (NSData) -> Entity?
}

struct ChildResource<Entity, Parent: Resource>: Resource {
    typealias Result = Entity
    let path: String
    let parent: Parent
    let parse: (NSData) -> Entity?
}

protocol Entity {
    static var path: String { get }
    init?(json: JSONDictionary)
}

func coerceJSONCollection(data: NSData) -> [JSONDictionary]? {
    guard let json = try? NSJSONSerialization.JSONObjectWithData(data, options: []) else {return nil}
    return json as? [JSONDictionary]
}

func coerceJSONEntity(data: NSData) -> JSONDictionary? {
    guard let json = try? NSJSONSerialization.JSONObjectWithData(data, options: []) else {return nil}
    return json as? JSONDictionary
}

protocol RootEntity: Entity {}

extension RootEntity {
    static func all() -> RootResource<[Self]> {
        return RootResource(path: Self.path) { data in
            return coerceJSONCollection(data)?.flatMap(Self.init)
        }
    }

    static func withID(id: String) -> RootResource<Self> {
        return RootResource(path: "\(Self.path)/\(id)") { data in
            guard let json = coerceJSONEntity(data) else {return nil}
            return Self.init(json: json)
        }
    }
}

protocol ChildEntity: Entity {
    associatedtype ParentEntity
}

extension ChildEntity {
    static func all<R where R: Resource, R.Result == ParentEntity>(parent: R) -> ChildResource<[Self], R> {
        return ChildResource(path: "\(parent.path)/\(Self.path)", parent: parent) { data in
            return coerceJSONCollection(data)?.flatMap(Self.init)
        }
    }

    static func all<R where R: Resource, R.Result == ParentEntity>() -> (R) -> ChildResource<[Self], R> {
        return { parent in
            return Self.all(parent)
        }
    }

    static func withID<R where R: Resource, R.Result == ParentEntity>(parent: R, id: String) -> ChildResource<Self, R> {
        return ChildResource(path: "\(parent.path)/\(Self.path)/\(id)", parent: parent) { data in
            guard let json = coerceJSONEntity(data) else {return nil}
            return Self.init(json: json)
        }
    }

    static func withID<R where R: Resource, R.Result == ParentEntity>(id: String) -> (R) -> ChildResource<Self, R> {
        return { parent in
            return Self.withID(parent, id: id)
        }
    }
}

func / <P, C where P: Resource, C: ChildEntity, P.Result == C.ParentEntity>(resource: P, fn: (P) -> ChildResource<C, P>) -> ChildResource<C, P> {
    return fn(resource)
}

func / <P, C where P: Resource, C: ChildEntity, P.Result == C.ParentEntity>(resource: P, fn: (P) -> ChildResource<[C], P>) -> ChildResource<[C], P> {
    return fn(resource)
}

final class WebService {
    let root: NSURL
    let session: NSURLSession

    init(root: NSURL) {
        self.root = root
        self.session = NSURLSession.sharedSession()
    }

    init(root: NSURL, configuration: NSURLSessionConfiguration) {
        self.root = root
        self.session = NSURLSession(configuration: configuration)
    }

    func load<R: Resource>(resource: R, completion: (R.Result?) -> Void) {
        let url = root.URLByAppendingPathComponent(resource.path)
        let task = session.dataTaskWithURL(url) { data, _, _ in
            if let data = data {
                completion(resource.parse(data))
            }
            else {
                completion(nil)
            }
        }

        task.resume()
    }
}

