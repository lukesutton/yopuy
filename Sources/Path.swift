public enum CollectionPath {}
public enum SingularPath {}

public enum GET {}
public enum POST {}
public enum PUT {}
public enum PATCH {}
public enum DELETE {}

public struct Path<R: Resource, Path, Method> {
    public let path: String
}

public struct ChildPath<R: ChildResource, Path, Method> {
    public let path: String
}

public func / <P, C, F, M>(lhs: Path<P, SingularPath, GET>, rhs: ChildPath<C, F, M>) -> Path<C, F, M>
    where P: IsShowable, C: ChildResource, C.Parent == P {
    return Path(path: "\(lhs.path)/\(rhs.path)")
}
