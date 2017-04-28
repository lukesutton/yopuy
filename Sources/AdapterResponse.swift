import Foundation

/**
  The response from a call to a `HTTPAdapter`. The cases encode the various
  possible states of the request.
*/
public enum AdapterResponse {
  /**
    A successful request, but one without any data.
  */
  case empty(headers: [String: String])

  /**
    A successful request, with a payload of `Data`.
  */
  case success(result: Data, headers: [String: String])

  /**
    An unsuccessful request, with a corresponding error. There is no restriction
    on the error returned.
  */
  case error(result: Error, headers: [String: String])
}
