import Yopuy
import Foundation

struct Adapter: HTTPAdapter {
  enum Response {
  case empty
  case error(Error)
  case collection([[String: Any]])
  case singular([String: Any])
  }

  let response: Response

  func perform(_ method: HTTPMethod, request: AdapterRequest, callback: @escaping (AdapterResponse) -> Void) {
    callback(encode(response))
  }

  private func encode(_ response: Response) -> AdapterResponse {
    switch response {
    case let .collection(data):
      return encodeJSON(data)
    case let .singular(data):
      return encodeJSON(data)
    case let .error(error):
      return .error(result: error, headers: [:])
    case .empty:
      return .empty(headers: [:])
    }
  }

  private func encodeJSON(_ object: Any) -> AdapterResponse {
    do {
      let data = try JSONSerialization.data(withJSONObject: object)
      return .success(result: data, headers: [:])
    }
    catch let error {
      return .error(result: error, headers: [:])
    }
  }
}
