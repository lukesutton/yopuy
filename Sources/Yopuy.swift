import Foundation

protocol Resource {
    associatedtype IDType
    static var path: String { get }
    init(json: [String: Any]) throws
}

protocol RootResource: Resource {

}

protocol ChildResource: Resource {
    associatedtype Parent: Resource
}

protocol IsListable: Resource {

}

extension IsListable where Self: RootResource {
    static var list: Path<Self, CollectionPath, GET> {
        return Path(path: path)
    }
}

extension IsListable where Self: ChildResource {
    static var list: ChildPath<Self, CollectionPath, GET> {
        return ChildPath(path: path)
    }
}

protocol IsShowable: Resource {

}

extension IsShowable where Self: RootResource {
    static func show(_ id: IDType) -> Path<Self, SingularPath, GET> {
        return Path(path: "\(path)/\(id)")
    }
}

extension IsShowable where Self: ChildResource {
    static func show(_ id: IDType) -> ChildPath<Self, SingularPath, GET> {
        return ChildPath(path: "\(path)/\(id)")
    }
}

protocol IsDeletable: Resource {

}

extension IsDeletable where Self: RootResource {
    static func delete(_ id: IDType) -> Path<Self, SingularPath, DELETE> {
        return Path(path: "\(path)/\(id)")
    }
}

extension IsDeletable where Self: ChildResource {
    static func delete(_ id: IDType) -> ChildPath<Self, SingularPath, DELETE> {
        return ChildPath(path: "\(path)/\(id)")
    }
}

protocol IsCreatable {

}

extension IsCreatable where Self: RootResource {
    static func delete(_ id: IDType) -> Path<Self, SingularPath, POST> {
        return Path(path: "\(path)/\(id)")
    }
}

extension IsCreatable where Self: ChildResource {
    static func delete(_ id: IDType) -> ChildPath<Self, SingularPath, POST> {
        return ChildPath(path: "\(path)/\(id)")
    }
}


protocol IsReplaceable {

}

extension IsReplaceable where Self: RootResource {
    static func delete(_ id: IDType) -> Path<Self, SingularPath, PUT> {
        return Path(path: "\(path)/\(id)")
    }
}

extension IsReplaceable where Self: ChildResource {
    static func delete(_ id: IDType) -> ChildPath<Self, SingularPath, PUT> {
        return ChildPath(path: "\(path)/\(id)")
    }
}

protocol IsPatchable {

}

extension IsPatchable where Self: RootResource {
    static func delete(_ id: IDType) -> Path<Self, SingularPath, PATCH> {
        return Path(path: "\(path)/\(id)")
    }
}

extension IsPatchable where Self: ChildResource {
    static func delete(_ id: IDType) -> ChildPath<Self, SingularPath, PATCH> {
        return ChildPath(path: "\(path)/\(id)")
    }
}

protocol IsRESTFul: IsListable, IsCreatable, IsShowable, IsReplaceable, IsPatchable, IsDeletable {

}

enum CollectionPath {}
enum SingularPath {}

enum GET {}
enum POST {}
enum PUT {}
enum PATCH {}
enum DELETE {}

struct Path<R: Resource, Path, Method> {
    let path: String
}

struct ChildPath<R: ChildResource, Path, Method> {
    let path: String
}

func / <P, C, F, M>(lhs: Path<P, SingularPath, GET>, rhs: ChildPath<C, F, M>) -> Path<C, F, M>
    where P: IsShowable, C: ChildResource, C.Parent == P {
    return Path(path: "\(lhs.path)/\(rhs.path)")
}

enum HTTPResult<Result> {
    case empty
    case data(Result)
    case error(Error)
}

protocol HTTPAdapter {
    typealias HTTPAdapterResult = HTTPResult<NSData>

    func get(path: String, query: [String: Any]?, callback: (HTTPAdapterResult) -> Void)
    func post(path: String, body: [String: Any], callback: (HTTPAdapterResult) -> Void)
    func put(path: String, body: [String: Any], callback: (HTTPAdapterResult) -> Void)
    func patch(path: String, body: [String: Any], callback: (HTTPAdapterResult) -> Void)
    func delete(path: String, callback: (HTTPAdapterResult) -> Void)
}

struct Service<Adapter: HTTPAdapter>  {
  typealias Handler<R> = (HTTPResult<R>) -> Void

  private let adapter: Adapter

  func call<R>(path: Path<R, CollectionPath, GET>, query: [String: Any]?, handler: Handler<[R]>) {
    adapter.get(path: path.path, query: query) { data in

    }
  }

  func call<R>(path: Path<R, CollectionPath, POST>, body: [String: Any], handler: Handler<[R]>) {
    adapter.post(path: path.path, body: body) { data in

    }
  }

  func call<R>(path: Path<R, SingularPath, GET>, query: [String: Any]?, handler: Handler<R>) {
    adapter.get(path: path.path, query: query) { result in

    }
  }
}
