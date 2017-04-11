import Foundation

struct URLGenerationError: Error {
  let message: String

  init(host: URL, path: String) {
    self.message = "Cannot create a full URL from the host \(host) and path \(path)"
  }
}

public struct Service<Adapter: HTTPAdapter>  {
  public typealias Handler<R> = (HTTPResult<R>) -> Void

  private let adapter: Adapter
  public let host: URL

  public init(adapter: Adapter, host: URL) {
    self.adapter = adapter
    self.host = host
  }

  public func call<R: Resource>(_ path: Path<R, CollectionPath, GET>, query: [String: Any]? = nil, handler: @escaping Handler<R.Collection>) {
    adapter.get(url: url(path), query: query) { result in
      handler(self.parse(result: result, with: R.parse(collection:)))
    }
  }

  public func call<R: Resource>(_ path: Path<R, SingularPath, POST>, body: [String: Any], handler: @escaping Handler<R.Singular>) {
    adapter.post(url: url(path), body: body) { result in
      handler(self.parse(result: result, with: R.parse(singular:)))
    }
  }

  public func call<R: Resource>(_ path: Path<R, SingularPath, GET>, query: [String: Any]? = nil, handler: @escaping Handler<R.Singular>) {
    adapter.get(url: url(path), query: query) { result in
      handler(self.parse(result: result, with: R.parse(singular:)))
    }
  }

  public func call<R: Resource>(_ path: Path<R, SingularPath, PUT>, body: [String: Any], handler: @escaping Handler<R.Singular>) {
    adapter.put(url: url(path), body: body) { result in
      handler(self.parse(result: result, with: R.parse(singular:)))
    }
  }

  public func call<R: Resource>(_ path: Path<R, SingularPath, PATCH>, body: [String: Any], handler: @escaping Handler<R.Singular>) {
    adapter.patch(url: url(path), body: body) { result in
      handler(self.parse(result: result, with: R.parse(singular:)))
    }
  }

  public func call<R: Resource>(_ path: Path<R, SingularPath, DELETE>, handler: @escaping Handler<R.Singular>) {
    adapter.delete(url: url(path)) { result in
      handler(self.parse(result: result, with: R.parse(singular:)))
    }
  }

  private func url<R, P, M>(_ path: Path<R, P, M>) -> URL {
    return URL(string: path.path, relativeTo: host)!
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
