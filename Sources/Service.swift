import Foundation

public struct Service<Adapter: HTTPAdapter>  {
  public typealias Handler<R> = (HTTPResult<R>) -> Void

  private let adapter: Adapter

  public init(adapter: Adapter) {
    self.adapter = adapter
  }

  public func call<R: Resource>(_ path: Path<R, CollectionPath, GET>, query: [String: Any]? = nil, handler: @escaping Handler<R.Collection>) {
    adapter.get(path: path.path, query: query) { result in
      handler(self.parse(result: result, with: R.parse(collection:)))
    }
  }

  public func call<R: Resource>(_ path: Path<R, SingularPath, POST>, body: [String: Any], handler: @escaping Handler<R.Singular>) {
    adapter.post(path: path.path, body: body) { result in
      handler(self.parse(result: result, with: R.parse(singular:)))
    }
  }

  public func call<R: Resource>(_ path: Path<R, SingularPath, GET>, query: [String: Any]? = nil, handler: @escaping Handler<R.Singular>) {
    adapter.get(path: path.path, query: query) { result in
      handler(self.parse(result: result, with: R.parse(singular:)))
    }
  }

  public func call<R: Resource>(_ path: Path<R, SingularPath, PUT>, body: [String: Any], handler: @escaping Handler<R.Singular>) {
    adapter.put(path: path.path, body: body) { result in
      handler(self.parse(result: result, with: R.parse(singular:)))
    }
  }

  public func call<R: Resource>(_ path: Path<R, SingularPath, PATCH>, body: [String: Any], handler: @escaping Handler<R.Singular>) {
    adapter.patch(path: path.path, body: body) { result in
      handler(self.parse(result: result, with: R.parse(singular:)))
    }
  }

  public func call<R: Resource>(_ path: Path<R, SingularPath, DELETE>, handler: @escaping Handler<R.Singular>) {
    adapter.delete(path: path.path) { result in
      handler(self.parse(result: result, with: R.parse(singular:)))
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
