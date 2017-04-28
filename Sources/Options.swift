/**
  The options for a request. It captures headers, query-string and request body.
*/
public struct Options {
  /**
    Optional request headers.
  */
  let headers: [Header]?

  /**
    Optional query string.
  */
  let query: [String: String]?

  /**
    Optional request body.
  */
  let body: String?

  /**
    Initialiser with default values for each property.
  */
  public init(headers: [Header]? = nil, query: [String: String]? = nil, body: String? = nil) {
    self.headers = headers
    self.query = query
    self.body = body
  }
}
