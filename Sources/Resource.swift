import Foundation

/**
  Defines the base requirements for types that interact with Yopuy.

  **Note:** This protocol should not be used directly, instead use the
  `RootResource` and `ChildResource` protocols.
*/
public protocol Resource {
    /**
      The type used to identify a resource e.g. a `UUID` or `String`
    */
    associatedtype ID

    /**
      The expected return type when parsing a single resource. This is explict
      rather than defaulting to `Self` so that custom wrapper types can be
      specified if required.
    */
    associatedtype Singular

    /**
      The expected return type when parsing a collection of resources. This is
      explict rather than defaulting to `[Self]` so that custom wrapper types
      can be specified if required.
    */
    associatedtype Collection

    /**
      A getter for a resource's identifier.
    */
    var id: ID { get }

    /**
      A getter for the string that represents a resource's collection e.g.
      `"users"` or `"posts"`. It should only be a partial path. It must _not_
      include the host or refer to parent resources.
    */
    static var path: String { get }

    /**
      A static function required for parsing a single resource. The `Data` is
      the result from a call to the network.
    */
    static func parse(singular data: Data) throws -> Singular

    /**
      A static function required for parsing a collection of resources. The
      `Data` is the result from a call to the network.
    */
    static func parse(collection data: Data) throws -> Collection
}

/**
  Defines a resource that exists at the root of the remote API.
*/
public protocol RootResource: Resource {

}

/**
  Defines a resource that is related to a parent resource, which may be a
  `RootResource` or another `ChildResource`. This is done via the
  `associatedtype Parent` declaration. This is used as a constraint in order to
  direct the type-safe construction of paths which are used for requests.
*/
public protocol ChildResource: Resource {
    /**
      The resource to which `Self` is related to.
    */
    associatedtype Parent: Resource
}

public protocol IsListable: Resource {
}

extension IsListable where Self: RootResource {
    public static var list: Path<Self, CollectionPath, GET> {
        return Path(path: path)
    }
}

extension IsListable where Self: ChildResource {
    public static var list: ChildPath<Self, CollectionPath, GET> {
        return ChildPath(path: path)
    }
}

public protocol IsShowable: Resource {

}

extension IsShowable where Self: RootResource {
    public static func show(_ id: ID) -> Path<Self, SingularPath, GET> {
        return Path(path: "\(path)/\(id)")
    }

    public var show: Path<Self, SingularPath, GET> {
      return Self.show(id)
    }
}

extension IsShowable where Self: ChildResource {
    public static func show(_ id: ID) -> ChildPath<Self, SingularPath, GET> {
        return ChildPath(path: "\(path)/\(id)")
    }

    public var show: ChildPath<Self, SingularPath, GET> {
      return Self.show(id)
    }
}

public protocol IsDeletable: Resource {

}

extension IsDeletable where Self: RootResource {
    public static func delete(_ id: ID) -> Path<Self, SingularPath, DELETE> {
        return Path(path: "\(path)/\(id)")
    }

    public var delete: Path<Self, SingularPath, DELETE> {
      return Self.delete(id)
    }
}

extension IsDeletable where Self: ChildResource {
    public static func delete(_ id: ID) -> ChildPath<Self, SingularPath, DELETE> {
        return ChildPath(path: "\(path)/\(id)")
    }

    public var delete: ChildPath<Self, SingularPath, DELETE> {
      return Self.delete(id)
    }
}

public protocol IsCreatable {

}

extension IsCreatable where Self: RootResource {
    public static var create: Path<Self, SingularPath, POST> {
        return Path(path: path)
    }
}

extension IsCreatable where Self: ChildResource {
    public static var create: ChildPath<Self, SingularPath, POST> {
        return ChildPath(path: path)
    }
}


public protocol IsReplaceable {

}

extension IsReplaceable where Self: RootResource {
    public static func replace(_ id: ID) -> Path<Self, SingularPath, PUT> {
        return Path(path: "\(path)/\(id)")
    }

    public var replace: Path<Self, SingularPath, PUT> {
      return Self.replace(id)
    }
}

extension IsReplaceable where Self: ChildResource {
    public static func replace(_ id: ID) -> ChildPath<Self, SingularPath, PUT> {
        return ChildPath(path: "\(path)/\(id)")
    }

    public var replace: ChildPath<Self, SingularPath, PUT> {
      return Self.replace(id)
    }
}

public protocol IsPatchable {

}

extension IsPatchable where Self: RootResource {
    public static func update(_ id: ID) -> Path<Self, SingularPath, PATCH> {
        return Path(path: "\(path)/\(id)")
    }

    public var update: Path<Self, SingularPath, PATCH> {
      return Self.update(id)
    }
}

extension IsPatchable where Self: ChildResource {
    public static func update(_ id: ID) -> ChildPath<Self, SingularPath, PATCH> {
        return ChildPath(path: "\(path)/\(id)")
    }

    public var update: ChildPath<Self, SingularPath, PATCH> {
      return Self.update(id)
    }
}

public protocol IsRESTFul: IsListable, IsCreatable, IsShowable, IsReplaceable, IsPatchable, IsDeletable {

}
