/**
  The enum used to represent the response from a call to the `Service` and also
  in the implementation of a `HTTPAdapter` handling HTTP requests.
*/
public enum HTTPResult<Result> {
    /**
     Indicates the request is successful, but has no return data associated with
     it.
    */
    case empty

    /**
      Indicates a successful request with it's associated data.
    */
    case data(Result)

    /**
      Indicates a request that has failed. This may contain an error from the
      `Service`, the `HTTPAdapter` or an error from attempting to parse the
      server response into a `Resource`.
    */
    case error(Error)
}
