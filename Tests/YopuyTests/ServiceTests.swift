import XCTest
import Yopuy

class ServiceTests: XCTestCase {
  let service = Service(adapter: Adapter(response: .empty))

  func testList() {
    let expect = expectation(description: "Testing list")
    let payload = [
      ["id": 1],
      ["id": 2]
    ]
    let service = Service(adapter: Adapter(response: .collection(payload)))
    service.call(Post.list) { result in
      switch result {
      case let .data(data):
        XCTAssertEqual(data, [Post(id: 1), Post(id: 2)])
      default:
        XCTFail()
      }

      expect.fulfill()
    }

    waitForExpectations(timeout: 10)
  }
}
