/**
  Encodings of the most common HTTP methods. These are passed by the `Service`
  to it's `HTTPAdapter`.
*/
public enum HTTPMethod {
  /**
    A `GET` request.
  */
  case GET

  /**
    A `POST` request.
  */
  case POST

  /**
    A `PUT` request.
  */
  case PUT

  /**
    A `PATCH` request.
  */
  case PATCH

  /**
    A `DELETE` request.
  */
  case DELETE
}
