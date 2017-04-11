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

/**
  Flags a resource as being listable i.e. it has a collection. This protocol
  does nothing by itself, but has constrained extensions for types implementing
  `RootResource` and `ChildResource`.
*/
public protocol IsListable: Resource {
}

extension IsListable where Self: RootResource {
    /**
      A static value for `RootResource` which returns a `Path` that encodes
      a `GET` request for listing resources.
    */
    public static var list: Path<Self, CollectionPath, GET> {
        return Path(path: path)
    }
}

extension IsListable where Self: ChildResource {
    /**
      A static value for `ChildResource` which returns a `Path` that encodes
      a `GET` request for listing resources.
    */
    public static var list: ChildPath<Self, CollectionPath, GET> {
        return ChildPath(path: path)
    }
}

/**
  Flags a resource as being showable i.e. a single resource can be requested.
  This protocol does nothing by itself, but has constrained extensions for types
  implementing `RootResource` and `ChildResource`.
*/
public protocol IsShowable: Resource {

}

extension IsShowable where Self: RootResource {
    /**
      A static function for `RootResource` which returns a `Path` that encodes
      a `GET` request for single resource.
    */
    public static func show(_ id: ID) -> Path<Self, SingularPath, GET> {
        return Path(path: "\(path)/\(id)")
    }

    /**
      A value for an instance of `RootResource` which returns a `Path`
      that encodes a `GET` request for that resource.
    */
    public var show: Path<Self, SingularPath, GET> {
      return Self.show(id)
    }
}

extension IsShowable where Self: ChildResource {
    /**
      A static function for `ChildResource` which returns a `Path` that encodes
      a `GET` request for single resource.
    */
    public static func show(_ id: ID) -> ChildPath<Self, SingularPath, GET> {
        return ChildPath(path: "\(path)/\(id)")
    }

    /**
      A value for an instance of `ChildResource` which returns a `Path`
      that encodes a `GET` request for that resource.
    */
    public var show: ChildPath<Self, SingularPath, GET> {
      return Self.show(id)
    }
}

/**
  Flags a resource as being deletable. This protocol does nothing by itself, but
  has constrained extensions for types implementing `RootResource` and
  `ChildResource`.
*/
public protocol IsDeletable: Resource {

}

extension IsDeletable where Self: RootResource {
    /**
      A static function for `RootResource` which returns a `Path` that encodes
      a `DELETE` request for single resource.
    */
    public static func delete(_ id: ID) -> Path<Self, SingularPath, DELETE> {
        return Path(path: "\(path)/\(id)")
    }

    /**
      A value for an instance of `RootResource` which returns a `Path`
      that encodes a `DELETE` request for that resource.
    */
    public var delete: Path<Self, SingularPath, DELETE> {
      return Self.delete(id)
    }
}

extension IsDeletable where Self: ChildResource {
    /**
      A static function for `ChildResource` which returns a `Path` that encodes
      a `DELETE` request for single resource.
    */
    public static func delete(_ id: ID) -> ChildPath<Self, SingularPath, DELETE> {
        return ChildPath(path: "\(path)/\(id)")
    }

    /**
      A value for an instance of `ChildResource` which returns a `Path`
      that encodes a `DELETE` request for that resource.
    */
    public var delete: ChildPath<Self, SingularPath, DELETE> {
      return Self.delete(id)
    }
}

/**
  Flags a resource as being creatable. This protocol does nothing by itself, but
  has constrained extensions for types implementing `RootResource` and
  `ChildResource`.
*/
public protocol IsCreatable {

}

extension IsCreatable where Self: RootResource {
    /**
      A static function for `RootResource` which returns a `Path` that encodes
      a `POST` request for single resource.
    */
    public static var create: Path<Self, SingularPath, POST> {
        return Path(path: path)
    }
}

extension IsCreatable where Self: ChildResource {
    /**
      A static function for `ChildResource` which returns a `Path` that encodes
      a `POST` request for single resource.
    */
    public static var create: ChildPath<Self, SingularPath, POST> {
        return ChildPath(path: path)
    }
}

/**
  Flags a resource as being replacable i.e. supports `PUT`. This protocol does
  nothing by itself, but has constrained extensions for types implementing
  `RootResource` and `ChildResource`.
*/
public protocol IsReplaceable {

}

extension IsReplaceable where Self: RootResource {
    /**
      A static function for `RootResource` which returns a `Path` that encodes
      a `PUT` request for single resource.
    */
    public static func replace(_ id: ID) -> Path<Self, SingularPath, PUT> {
        return Path(path: "\(path)/\(id)")
    }

    /**
      A value for an instance of `RootResource` which returns a `Path`
      that encodes a `PUT` request for that resource.
    */
    public var replace: Path<Self, SingularPath, PUT> {
      return Self.replace(id)
    }
}

extension IsReplaceable where Self: ChildResource {
    /**
      A static function for `ChildResource` which returns a `Path` that encodes
      a `PUT` request for single resource.
    */
    public static func replace(_ id: ID) -> ChildPath<Self, SingularPath, PUT> {
        return ChildPath(path: "\(path)/\(id)")
    }

    /**
      A value for an instance of `ChildResource` which returns a `Path`
      that encodes a `PUT` request for that resource.
    */
    public var replace: ChildPath<Self, SingularPath, PUT> {
      return Self.replace(id)
    }
}

/**
  Flags a resource as being patchable i.e. supports `PATCH`. This protocol does
  nothing by itself, but has constrained extensions for types implementing
  `RootResource` and `ChildResource`.
*/
public protocol IsPatchable {

}

extension IsPatchable where Self: RootResource {
    /**
      A static function for `RootResource` which returns a `Path` that encodes
      a `PATCH` request for single resource.
    */
    public static func update(_ id: ID) -> Path<Self, SingularPath, PATCH> {
        return Path(path: "\(path)/\(id)")
    }

    /**
      A value for an instance of `RootResource` which returns a `Path`
      that encodes a `PATCH` request for that resource.
    */
    public var update: Path<Self, SingularPath, PATCH> {
      return Self.update(id)
    }
}

extension IsPatchable where Self: ChildResource {
    /**
      A static function for `ChildResource` which returns a `Path` that encodes
      a `PATCH` request for single resource.
    */
    public static func update(_ id: ID) -> ChildPath<Self, SingularPath, PATCH> {
        return ChildPath(path: "\(path)/\(id)")
    }

    /**
      A value for an instance of `ChildResource` which returns a `Path`
      that encodes a `PATCH` request for that resource.
    */
    public var update: ChildPath<Self, SingularPath, PATCH> {
      return Self.update(id)
    }
}

/**
  A convenience protocol which allows a resource to opt into all of the `Is*`
  protocols. It will add:

  - `IsListable`
  - `IsCreatable`
  - `IsShowable`
  - `IsReplaceable`
  - `IsPatchable`
  - `IsDeletable`
*/
public protocol IsRESTFul: IsListable, IsCreatable, IsShowable, IsReplaceable, IsPatchable, IsDeletable {

}
