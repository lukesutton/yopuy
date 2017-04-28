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
      Issue a HTTP request, where the HTTP method is specified via the `HTTPMethod`
      enum e.g. `.GET`.
    */
    func perform(_ method: HTTPMethod, request: AdapterRequest, callback: @escaping (AdapterResponse) -> Void)
}
