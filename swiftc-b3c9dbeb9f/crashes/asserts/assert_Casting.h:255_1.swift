public struct Foo<A,B,C>{}

public protocol P{
    associatedtype PA
    associatedtype PB
    associatedtype PC = Never
    typealias CC = Foo<PA,PB,PC>
    func f0(_:CC,_:PA)
    func f0(_:CC,_:PB)
    func f0(_:CC,_:PC)
    func f(_:CC)
}

public extension P{
    public func f(_:PB){}
    func f0(_:CC,_:PC){}
    public func f(_:CC){}
}

public struct S:P{
    public typealias P0 = String
    public typealias B = Int
    public func f(_:CC,_:P0){}
    public func f0(_:CC,_:P)
}
