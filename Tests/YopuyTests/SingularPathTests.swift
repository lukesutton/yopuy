import XCTest
import Yopuy

class SingularPathTests: XCTestCase {
  func testSingularRootShowPath() {
    let path = Blog.show
    XCTAssert((path as Any) is Path<Blog, SingularPath, GET>)
    XCTAssertEqual(path.path, "blog")
  }

  func testSingularRootCreatePath() {
    let path = Blog.create
    XCTAssert((path as Any) is Path<Blog, SingularPath, POST>)
    XCTAssertEqual(path.path, "blog")
  }
  func testSingularRootReplacePath() {
    let path = Blog.replace
    XCTAssert((path as Any) is Path<Blog, SingularPath, PUT>)
    XCTAssertEqual(path.path, "blog")
  }

  func testSingularRootUpdatePath() {
    let path = Blog.update
    XCTAssert((path as Any) is Path<Blog, SingularPath, PATCH>)
    XCTAssertEqual(path.path, "blog")
  }

  func testSingularRootDeletePath() {
    let path = Blog.delete
    XCTAssert((path as Any) is Path<Blog, SingularPath, DELETE>)
    XCTAssertEqual(path.path, "blog")
  }

  func testSingularChildShowPath() {
    let path = Blog.show / Author.show
    XCTAssert((path as Any) is Path<Author, SingularPath, GET>)
    XCTAssertEqual(path.path, "blog/author")
  }

  func testSingularChildCreatePath() {
    let path = Blog.show / Author.create
    XCTAssert((path as Any) is Path<Author, SingularPath, POST>)
    XCTAssertEqual(path.path, "blog/author")
  }

  func testSingularChildReplacePath() {
    let path = Blog.show / Author.replace
    XCTAssert((path as Any) is Path<Author, SingularPath, PUT>)
    XCTAssertEqual(path.path, "blog/author")
  }

  func testSingularChildUpdatePath() {
    let path = Blog.show / Author.update
    XCTAssert((path as Any) is Path<Author, SingularPath, PATCH>)
    XCTAssertEqual(path.path, "blog/author")
  }

  func testSingularChildDeletePath() {
    let path = Blog.show / Author.delete
    XCTAssert((path as Any) is Path<Author, SingularPath, DELETE>)
    XCTAssertEqual(path.path, "blog/author")
  }
}
