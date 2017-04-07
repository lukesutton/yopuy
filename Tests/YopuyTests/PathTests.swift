import XCTest
import Yopuy

class PathTests: XCTestCase {
  func testRootListPath() {
    let path = Post.list
    XCTAssert((path as Any) is Path<Post, CollectionPath, GET>)
    XCTAssertEqual(path.path, "posts")
  }

  func testRootShowPath() {
    let path = Post.show(1)
    XCTAssert((path as Any) is Path<Post, SingularPath, GET>)
    XCTAssertEqual(path.path, "posts/1")
  }

  func testRootCreatePath() {
    let path = Post.create
    XCTAssert((path as Any) is Path<Post, CollectionPath, POST>)
    XCTAssertEqual(path.path, "posts")
  }

  func testRootUpdatePath() {
    let path = Post.update(2)
    XCTAssert((path as Any) is Path<Post, SingularPath, PATCH>)
    XCTAssertEqual(path.path, "posts/2")
  }

  func testRootReplacePath() {
    let path = Post.replace(2)
    XCTAssert((path as Any) is Path<Post, SingularPath, PUT>)
    XCTAssertEqual(path.path, "posts/2")
  }

  func testRootDeletePath() {
    let path = Post.delete(2)
    XCTAssert((path as Any) is Path<Post, SingularPath, DELETE>)
    XCTAssertEqual(path.path, "posts/2")
  }

  func testNestedListPath() {
    let path = Post.show(2) / Comment.list
    XCTAssert((path as Any) is Path<Comment, CollectionPath, GET>)
    XCTAssertEqual(path.path, "posts/2/comments")
  }

  func testNestedShowPath() {
    let path = Post.show(2) / Comment.show(12)
    XCTAssert((path as Any) is Path<Comment, SingularPath, GET>)
    XCTAssertEqual(path.path, "posts/2/comments/12")
  }

  func testNestedCreatePath() {
    let path = Post.show(2) / Comment.create
    XCTAssert((path as Any) is Path<Comment, CollectionPath, POST>)
    XCTAssertEqual(path.path, "posts/2/comments")
  }

  func testNestedUpdatePath() {
    let path = Post.show(2) / Comment.update(19)
    XCTAssert((path as Any) is Path<Comment, SingularPath, PATCH>)
    XCTAssertEqual(path.path, "posts/2/comments/19")
  }

  func testNestedReplacePath() {
    let path = Post.show(2) / Comment.replace(19)
    XCTAssert((path as Any) is Path<Comment, SingularPath, PUT>)
    XCTAssertEqual(path.path, "posts/2/comments/19")

  func testNestedDeletePath() {
    let path = Post.show(2) / Comment.delete(19)
    XCTAssert((path as Any) is Path<Comment, SingularPath, DELETE>)
    XCTAssertEqual(path.path, "posts/2/comments/19")
  }}
}
