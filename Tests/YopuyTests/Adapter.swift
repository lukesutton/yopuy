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

  func get(path: String, query: [String: Any]?, callback: (HTTPAdapterResult) -> Void) {
    callback(encode(response))
  }

  func post(path: String, body: [String: Any], callback: (HTTPAdapterResult) -> Void) {
    callback(encode(response))
  }

  func put(path: String, body: [String: Any], callback: (HTTPAdapterResult) -> Void) {
    callback(encode(response))
  }

  func patch(path: String, body: [String: Any], callback: (HTTPAdapterResult) -> Void) {
    callback(encode(response))
  }

  func delete(path: String, callback: (HTTPAdapterResult) -> Void) {
    callback(encode(response))
  }

  private func encode(_ response: Response) -> HTTPAdapterResult {
    switch response {
    case let .collection(data):
      return encodeJSON(data)
    case let .singular(data):
      return encodeJSON(data)
    case let .error(error):
      return .error(error)
    case .empty:
      return .empty
    }
  }

  private func encodeJSON(_ object: Any) -> HTTPAdapterResult {
    do {
      let data = try JSONSerialization.data(withJSONObject: object)
      return .data(data)
    }
    catch let error {
      return .error(error)
    }
  }
}
