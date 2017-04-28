import XCTest
import Yopuy

class ServiceTests: XCTestCase {
  let host = URL(string: "https://example.com")!

  func testList() {
    let expect = expectation(description: "Testing list")
    let payload = [
      ["id": 1],
      ["id": 2]
    ]
    let service = Service(adapter: Adapter(response: .collection(payload)), host: host)
    service.call(Post.list) { result in
      switch result {
      case let .success(_, data, _):
        XCTAssertEqual(data, [Post(id: 1), Post(id: 2)])
      default:
        XCTFail()
      }

      expect.fulfill()
    }

    waitForExpectations(timeout: 10)
  }

  func testShow() {
    let expect = expectation(description: "Testing show")
    let payload = ["id": 2]
    let service = Service(adapter: Adapter(response: .singular(payload)), host: host)
    service.call(Post.show(2)) { result in
      switch result {
      case let .success(_, data, _):
        XCTAssertEqual(data, Post(id: 2))
      default:
        XCTFail()
      }

      expect.fulfill()
    }

    waitForExpectations(timeout: 10)
  }

  func testCreate() {
    let expect = expectation(description: "Testing create")
    let payload = ["id": 2]
    let service = Service(adapter: Adapter(response: .singular(payload)), host: host)
    service.call(Post.create, options: Options(body: "what")) { result in
      switch result {
      case let .success(_, data, _):
        XCTAssertEqual(data, Post(id: 2))
      default:
        XCTFail()
      }

      expect.fulfill()
    }

    waitForExpectations(timeout: 10)
  }

  func testReplace() {
    let expect = expectation(description: "Testing replace")
    let payload = ["id": 2]
    let service = Service(adapter: Adapter(response: .singular(payload)), host: host)
    service.call(Post.replace(2), options: Options(body: "what")) { result in
      switch result {
      case let .success(_, data, _):
        XCTAssertEqual(data, Post(id: 2))
      default:
        XCTFail()
      }

      expect.fulfill()
    }

    waitForExpectations(timeout: 10)
  }

  func testUpdate() {
    let expect = expectation(description: "Testing update")
    let payload = ["id": 2]
    let service = Service(adapter: Adapter(response: .singular(payload)), host: host)
    service.call(Post.update(2), options: Options(body: "what")) { result in
      switch result {
      case let .success(_, data, _):
        XCTAssertEqual(data, Post(id: 2))
      default:
        XCTFail()
      }

      expect.fulfill()
    }

    waitForExpectations(timeout: 10)
  }

  func testDelete() {
    let expect = expectation(description: "Testing delete")
    let service = Service(adapter: Adapter(response: .empty), host: host)
    service.call(Post.delete(2)) { result in
      switch result {
      case .empty:
        XCTAssertTrue(true)
      default:
        XCTFail()
      }

      expect.fulfill()
    }

    waitForExpectations(timeout: 10)
  }
}
