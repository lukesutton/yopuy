import Foundation
import Unbox

typealias JSONDictionary = [String: AnyObject]

protocol Resource {
    associatedtype Result
    associatedtype Flag
    var path: String { get }
}

struct ListedEntity {}
struct SingleEntity {}

struct RootResource<Entity, F>: Resource {
    typealias Result = Entity
    typealias Flag = F
    let path: String
}

struct ChildResource<Entity, F, Parent: Resource>: Resource {
    typealias Result = Entity
    typealias Flag = F
    let path: String
    let parent: Parent
}

protocol Entity: Unboxable {
    static var path: String { get }
}

protocol ListableEntity: Entity {}

protocol SingletonEntity: Entity {}

protocol CreatableEntity: Entity {}

protocol ReadableEntity: Entity {}

protocol UpdatableEntity: Entity {}

protocol DestroyableEntity: Entity {}

protocol FullEntity: ListableEntity, CreatableEntity, ReadableEntity, UpdatableEntity, DestroyableEntity {}

protocol RootEntity: Entity {}

extension RootEntity where Self: ListableEntity {
    static func list() -> RootResource<Self, ListedEntity> {
        return RootResource(path: Self.path)
    }
}

extension RootEntity where Self: ReadableEntity {
    static func withID(id: String) -> RootResource<Self, SingleEntity> {
        return RootResource(path: "\(Self.path)/\(id)")
    }
}

protocol ChildEntity: Entity {
    associatedtype ParentEntity
}

extension ChildEntity where Self: ListableEntity {
    static func list<R where R: Resource, R.Result == ParentEntity>(parent: R) -> ChildResource<Self, ListedEntity, R> {
        return ChildResource(path: "\(parent.path)/\(Self.path)", parent: parent)
    }

    static func list<R where R: Resource, R.Result == ParentEntity>() -> (R) -> ChildResource<Self, ListedEntity, R> {
        return { parent in
            return Self.list(parent)
        }
    }
}

extension ChildEntity where Self: ReadableEntity {
    static func withID<R where R: Resource, R.Result == ParentEntity>(parent: R, id: String) -> ChildResource<Self, SingleEntity, R> {
        return ChildResource(path: "\(parent.path)/\(Self.path)/\(id)", parent: parent)
    }

    static func withID<R where R: Resource, R.Result == ParentEntity>(id: String) -> (R) -> ChildResource<Self, SingleEntity, R> {
        return { parent in
            return Self.withID(parent, id: id)
        }
    }
}

func / <P, C, X where P: Resource, C: ChildEntity, P.Result == C.ParentEntity>(resource: P, fn: (P) -> ChildResource<C, X, P>) -> ChildResource<C, X, P> {
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

    func list<R where R: Resource, R.Result: protocol<ListableEntity, Entity>, R.Flag == ListedEntity>(resource: R, completion: ([R.Result]?) -> Void) {
        let url = root.URLByAppendingPathComponent(resource.path)
        let task = session.dataTaskWithURL(url) { data, _, _ in
            if let data = data {
              let result: [R.Result]? = try? Unbox(data)
              completion(result)
            }
            else {
              completion(nil)
            }
        }
        task.resume()
    }

    func read<R where R: Resource, R.Result: protocol<ReadableEntity, Entity>, R.Flag == SingleEntity>(resource: R) {

    }

    func create<R where R: Resource, R.Result: protocol<CreatableEntity, Entity>, R.Flag == SingleEntity>(resource: R) {

    }

    func update<R where R: Resource, R.Result: protocol<UpdatableEntity, Entity>, R.Flag == SingleEntity>(resource: R) {

    }

    func destroy<R where R: Resource, R.Result: protocol<DestroyableEntity, Entity>, R.Flag == SingleEntity>(resource: R) {

    }
}
