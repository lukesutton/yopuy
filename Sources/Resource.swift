import Foundation

public protocol Resource {
    associatedtype ID
    associatedtype Singular
    associatedtype Collection
    var id: ID { get }
    static var path: String { get }
    static func parse(singular data: Data) throws -> Singular
    static func parse(collection data: Data) throws -> Collection
}

public protocol RootResource: Resource {

}

public protocol ChildResource: Resource {
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
    public static var create: Path<Self, CollectionPath, POST> {
        return Path(path: path)
    }
}

extension IsCreatable where Self: ChildResource {
    public static var create: ChildPath<Self, CollectionPath, POST> {
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
