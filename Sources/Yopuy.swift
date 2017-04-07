import Foundation

protocol Resource {
    associatedtype IDType
    associatedtype SingularType
    associatedtype CollectionType
    static var path: String { get }
    static func parseSingular(data: Data) throws -> SingularType
    static func parseCollection(data: Data) throws -> CollectionType
}

protocol RootResource: Resource {

}

protocol ChildResource: Resource {
    associatedtype Parent: Resource
}

protocol Defaults: Resource {
  init(json: [String: Any]) throws
}

extension Defaults {
  static func parseCollection(data: Data) throws -> [Self] {
       let json = try JSONSerialization.jsonObject(with: data) as! [[String: Any]]
       let resources = try json.map { try Self(json: $0) }
       return resources
  }

  static func parseSingular(data: Data) throws -> Self {
       let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
       let resource = try Self(json: json)
       return resource
  }
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
    typealias HTTPAdapterResult = HTTPResult<Data>

    func get(path: String, query: [String: Any]?, callback: (HTTPAdapterResult) -> Void)
    func post(path: String, body: [String: Any], callback: (HTTPAdapterResult) -> Void)
    func put(path: String, body: [String: Any], callback: (HTTPAdapterResult) -> Void)
    func patch(path: String, body: [String: Any], callback: (HTTPAdapterResult) -> Void)
    func delete(path: String, callback: (HTTPAdapterResult) -> Void)
}

struct Service<Adapter: HTTPAdapter>  {
  typealias Handler<R> = (HTTPResult<R>) -> Void

  private let adapter: Adapter

  func call<R: Resource>(path: Path<R, CollectionPath, GET>, query: [String: Any]?, handler: Handler<R.CollectionType>) {
    adapter.get(path: path.path, query: query) { result in
      handler(parse(result: result, with: R.parseCollection))
    }
  }

  func call<R: Resource>(path: Path<R, CollectionPath, POST>, body: [String: Any], handler: Handler<R.CollectionType>) {
    adapter.post(path: path.path, body: body) { result in
      handler(parse(result: result, with: R.parseCollection))
    }
  }

  func call<R: Resource>(path: Path<R, SingularPath, GET>, query: [String: Any]?, handler: Handler<R.SingularType>) {
    adapter.get(path: path.path, query: query) { result in
      handler(parse(result: result, with: R.parseSingular))
    }
  }

  func call<R: Resource>(path: Path<R, SingularPath, PUT>, body: [String: Any], handler: Handler<R.SingularType>) {
    adapter.put(path: path.path, body: body) { result in
      handler(parse(result: result, with: R.parseSingular))
    }
  }

  func call<R: Resource>(path: Path<R, SingularPath, PATCH>, body: [String: Any], handler: Handler<R.SingularType>) {
    adapter.patch(path: path.path, body: body) { result in
      handler(parse(result: result, with: R.parseSingular))
    }
  }

  func call<R: Resource>(path: Path<R, SingularPath, DELETE>, handler: Handler<R.SingularType>) {
    adapter.delete(path: path.path) { result in
      handler(parse(result: result, with: R.parseSingular))
    }
  }

  private func parse<T>(result: HTTPResult<Data>, with parser: (Data) throws -> T) -> HTTPResult<T> {
    switch result {
    case .empty:
      return .empty
    case let .error(error):
      return .error(error)
    case let .data(data):
      do {
        let result = try parser(data)
        return .data(result)
      }
      catch let error {
        return .error(error)
      }
    }
  }
}
