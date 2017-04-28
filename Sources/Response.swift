/**
  The response value passed back to handlers calling the `Service`. It encodes
  the success or failure of a request.
*/
public enum Response<R: Resource, P, M, Payload> {
  /**
    The request was successful, but returned no data.
  */
  case empty(path: Path<R, P, M>, headers: [Header])

  /**
    The request was successful and has a payload.
  */
  case success(path: Path<R, P, M>, result: Payload, headers: [Header])

  /**
    There was an error processing the request. This case captures an `Error`
    value that describes the issue.
  */
  case error(path: Path<R, P, M>, result: Error, headers: [Header])
}
