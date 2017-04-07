public enum HTTPResult<Result> {
    case empty
    case data(Result)
    case error(Error)
}
