import Foundation

protocol FooBar {
    var foo: String { get }
    var bar: Int { get }
}

struct FooBarStruct: Codable, Equatable, FooBar {
    let foo: String
    let bar: Int

    static func ==(lhs: FooBarStruct, rhs: FooBarStruct) -> Bool {
        return lhs.foo == rhs.foo &&
            lhs.bar == rhs.bar
    }
}

final class FooBarClass: NSObject, NSCoding, FooBar {
    let foo: String
    let bar: Int

    private let fooKey = "FOO"
    private let barKey = "BAR"

    init(foo: String, bar: Int) {
        self.foo = foo
        self.bar = bar
        super.init()
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(foo, forKey: fooKey)
        aCoder.encode(bar, forKey: barKey)
    }

    required init?(coder aDecoder: NSCoder) {
        self.foo = aDecoder.decodeObject(forKey: fooKey) as! String
        self.bar = aDecoder.decodeInteger(forKey: barKey)
    }
}
