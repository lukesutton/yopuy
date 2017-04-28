import Foundation

/**
  A struct which wraps interaction with a remote API. It delegates all the HTTP
  requests to the underlying adapter.
*/
public struct Service<Adapter: HTTPAdapter>  {
  private let adapter: Adapter

  /**
    The root URL for the remote API. All requests will be made relative to this.
  */
  public let host: URL

  /**
    The default configuration that will be applied to every request.
  */
  public let options: Options

  /**
    Create a new instance of a service using an adapter and a root URL.
  */
  public init(adapter: Adapter, host: URL, options: Options = Options()) {
    self.adapter = adapter
    self.host = host
    self.options = options
  }

  /**
    The handler function for service calls which return single resources.
  */
  public typealias SingularHandler<R: Resource, M> = (Response<R, SingularPath, M, R.Singular>) -> Void

  /**
    The handler function for service calls which return a collection of
    resources.
  */
  public typealias CollectionHandler<R: IdentifiableResource, M> = (Response<R, CollectionPath, M, R.Collection>) -> Void

  /**
    Makes a `GET` request to an endpoint which returns a collection.
  */
  public func call<R: IdentifiableResource>(_ path: Path<R, CollectionPath, GET>, options: Options = Options(), handler: @escaping CollectionHandler<R, GET>) {
    perform(.GET, path, options: options, handler: handler, parser: R.parse(collection:))
  }

  /**
    Makes a `POST` request to an endpoint which returns a resource.
  */
  public func call<R: Resource>(_ path: Path<R, SingularPath, POST>, options: Options = Options(), handler: @escaping SingularHandler<R, POST>) {
    perform(.POST, path, options: options, handler: handler, parser: R.parse(singular:))
  }

  /**
    Makes a `GET` request to an endpoint which returns a resource.
  */
  public func call<R: Resource>(_ path: Path<R, SingularPath, GET>, options: Options = Options(), handler: @escaping SingularHandler<R, GET>) {
    perform(.GET, path, options: options, handler: handler, parser: R.parse(singular:))
  }

  /**
    Makes a `PUT` request to an endpoint which returns a resource.
  */
  public func call<R: Resource>(_ path: Path<R, SingularPath, PUT>, options: Options = Options(), handler: @escaping SingularHandler<R, PUT>) {
    perform(.PUT, path, options: options, handler: handler, parser: R.parse(singular:))
  }

  /**
    Makes a `PATCH` request to an endpoint which returns a resource.
  */
  public func call<R: Resource>(_ path: Path<R, SingularPath, PATCH>, options: Options = Options(), handler: @escaping SingularHandler<R, PATCH>) {
    perform(.PATCH, path, options: options, handler: handler, parser: R.parse(singular:))
  }

  /**
    Makes a `DELETE` request to an endpoint which returns a resource.
  */
  public func call<R: Resource>(_ path: Path<R, SingularPath, DELETE>, options: Options = Options(), handler: @escaping SingularHandler<R, DELETE>) {
    perform(.DELETE, path, options: options, handler: handler, parser: R.parse(singular:))
  }

  /**
    Performs the actual request. Generates a `Request` object and handles the
    response from the underlying adapter, mapping it to the `Response` which is
    sent to the handler.
  */
  private func perform<R: Resource, P, M, Result>(
    _ method: HTTPMethod,
    _ path: Path<R, P, M>,
    options: Options,
    handler: @escaping (Response<R, P, M, Result>) -> Void,
    parser: @escaping (Data) throws -> Result) {
    // TODO: Catch errors with the URL generation
    let request = Request<R, P, M>(
      path: path,
      URL: URL(string: path.path, relativeTo: host)!,
      headers: merge(self.options.headers, options.headers, with: mergeHeaders),
      query: merge(self.options.query, options.query, with: mergeQueries),
      body: options.body
    )

    adapter.perform(method, request: request) { raw in
      switch raw {
      case let .error(error, _):
        handler(Response<R, P, M, Result>.error(path: path, result: error, headers: []))
      case .empty:
        handler(Response<R, P, M, Result>.empty(path: path, headers: []))
      case let .success(result, _):
        do {
          let result = try parser(result)
          handler(Response<R, P, M, Result>.success(path: path, result: result, headers: []))
        }
        catch let error {
          handler(Response<R, P, M, Result>.error(path: path, result: error, headers: []))
        }
      }
    }
  }

  private func merge<A>(_ a: A?, _ b: A?, with op: (A, A) -> A) -> A? {
    guard let a = a else { return b }
    guard let b = b else { return a }
    return op(a, b)
  }

  private func mergeHeaders(_ a: [Header], _ b: [Header]) -> [Header] {
    let keys = b.map { $0.pair.0 }
    let filtered = a.filter { !keys.contains($0.pair.0) }
    return filtered + b
  }

  private func mergeQueries(_ a: [String: String], _ b: [String: String]) -> [String: String] {
    var result = a
    for (k, v) in b {
        result.updateValue(v, forKey: k)
    }
    return result
  }
}
