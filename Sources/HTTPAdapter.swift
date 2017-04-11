import Foundation

/**
  The adapter for making HTTP requests. This may be implemented as an extension
  to a HTTP client or a custom type that implements this protocol.

  It's entirely async, with all methods receiving a callback. The adapter
  communicates success or failure to the callback using the `HTTPAdapterResult`
  enum, which encodes success and failure.

  All the implementation details around encoding values and generating requests
  is left to the adapter and underlying client.

  For example, the here are some of the adapter's responsibility:

  - Authentication
  - Content negotiation
  - Caching
*/
public protocol HTTPAdapter {
    /**
      The response given to the callback in each of the request functions.
    */
    typealias HTTPAdapterResult = HTTPResult<Data>

    /**
      Generate a GET request. The query should be translated to a query-string
      and appended to the URL.
    */
    func get(url: URL, query: [String: Any]?, callback: @escaping (HTTPAdapterResult) -> Void)

    /**
      Generate a POST request. The body should be converted and added to the
      request body.
    */
    func post(url: URL, body: [String: Any], callback: @escaping (HTTPAdapterResult) -> Void)

    /**
      Generate a PUT request. The body should be converted and added to the
      request body.
    */
    func put(url: URL, body: [String: Any], callback: @escaping (HTTPAdapterResult) -> Void)

    /**
      Generate a POST request. The body should be converted and added to the
      request body.
    */
    func patch(url: URL, body: [String: Any], callback: @escaping (HTTPAdapterResult) -> Void)

    /**
      Generate a DELETE request.
    */
    func delete(url: URL, callback: @escaping (HTTPAdapterResult) -> Void)
}
