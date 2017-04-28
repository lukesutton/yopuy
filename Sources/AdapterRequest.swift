import Foundation

/**
  Requests that the `Service` sends to the `HTTPAdapter`. This is actually just
  wraps the `Request` struct, erasing the `Path` type so the adapter doesn't
  have to deal with it.
*/
public protocol AdapterRequest {
  /**
    The fully qualified URL for the request.
  */
  var URL: URL { get }

  /**
    The request headers.
  */
  var headers: [String: String]? { get }

  /**
    The query string. The adapter is expected to encode these and append them
    to the URL. They are provided as a `Dictionary` so that they can be
    manipulated or added to.
  */
  var query: [String: String]? { get }

  /**
    The body of the request. Generally only relevant for `POST`, `PUT` and
    `PATCH` requests, but the HTTP spec does allow a body for `GET` as well.
  */
  var body: String? { get }
}
