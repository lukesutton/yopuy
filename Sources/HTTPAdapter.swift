import Foundation

public protocol HTTPAdapter {
    typealias HTTPAdapterResult = HTTPResult<Data>

    func get(path: String, query: [String: Any]?, callback: @escaping (HTTPAdapterResult) -> Void)
    func post(path: String, body: [String: Any], callback: @escaping (HTTPAdapterResult) -> Void)
    func put(path: String, body: [String: Any], callback: @escaping (HTTPAdapterResult) -> Void)
    func patch(path: String, body: [String: Any], callback: @escaping (HTTPAdapterResult) -> Void)
    func delete(path: String, callback: @escaping (HTTPAdapterResult) -> Void)
}
