/**
  Defines headers as an enum. Defines the canonical set of headers. Custom
  headers can be encoded using the `other` case.
*/
public enum Header {
    /**
      Bearer authorization, generally used with OAuth or token-based
      authentication.
    */
    case bearerAuth(String)

    /**
      The etag header used for caching.
    */
    case eTag(String)

    /**
      Allows the definition of a custom header.
    */
    case other(String, String)

    /**
      Renders the header into a tuple of `String` values.
    */
    public var pair: (String, String) {
      switch self {
      case let .bearerAuth(token):
        return ("Authorization", token)
      case let .eTag(tag):
        return ("etag", tag)
      case let .other(key, value):
        return (key, value)
      }
    }
}
