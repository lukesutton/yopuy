import Foundation

public protocol HTTPAdapter {
    typealias HTTPAdapterResult = HTTPResult<Data>

    func get(path: String, query: [String: Any]?, callback: (HTTPAdapterResult) -> Void)
    func post(path: String, body: [String: Any], callback: (HTTPAdapterResult) -> Void)
    func put(path: String, body: [String: Any], callback: (HTTPAdapterResult) -> Void)
    func patch(path: String, body: [String: Any], callback: (HTTPAdapterResult) -> Void)
    func delete(path: String, callback: (HTTPAdapterResult) -> Void)
}
