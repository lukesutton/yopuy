import Foundation

public protocol HTTPAdapter {
    typealias HTTPAdapterResult = HTTPResult<Data>

    func get(url: URL, query: [String: Any]?, callback: @escaping (HTTPAdapterResult) -> Void)
    func post(url: URL, body: [String: Any], callback: @escaping (HTTPAdapterResult) -> Void)
    func put(url: URL, body: [String: Any], callback: @escaping (HTTPAdapterResult) -> Void)
    func patch(url: URL, body: [String: Any], callback: @escaping (HTTPAdapterResult) -> Void)
    func delete(url: URL, callback: @escaping (HTTPAdapterResult) -> Void)
}
