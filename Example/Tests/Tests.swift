import XCTest
@testable import EZKeychain

class EZKeychainTests: XCTestCase {

    private let testKey = "Testing.key"
    private let testStringValue = "Test string value"
    private let testData = NSKeyedArchiver.archivedData(withRootObject: [111.11, 999.99])
    private let testCodable = FooBarStruct(foo: "Foo", bar: 11)
    private let testCoding = FooBarClass(foo: "Foo", bar: 11)
    private let testDouble = 111.11
    private let testArray = [111.11, 999.99]

    var keychain: EZKeychain!

    override func setUp() {
        super.setUp()
        keychain = EZKeychain.shared
    }

    override func tearDown() {
        keychain.clear(key: testKey)
        keychain = nil
        super.tearDown()
    }

    // MARK: - clear
    func testClear() {
        keychain.writeData(key: testKey, value: testData)
        XCTAssertNotNil(keychain.readData(key: testKey))
        keychain.clear(key: testKey)
        XCTAssertNil(keychain.readData(key: testKey))
    }

    // MARK: - string
    func testWriteString() {
        keychain.writeString(key: testKey, value: testStringValue)
        XCTAssertEqual(keychain.readString(key: testKey), testStringValue)
    }

    func testReadString() {
        XCTAssertNil(keychain.readString(key: testKey))
        keychain.writeString(key: testKey, value: testStringValue)
        XCTAssertEqual(keychain.readString(key: testKey), testStringValue)
    }

    // MARK: - data
    func testWriteData() {
        keychain.writeData(key: testKey, value: testData)
        XCTAssertEqual(keychain.readData(key: testKey), testData)
    }

    func testReadData() {
        XCTAssertNil(keychain.readData(key: testKey))
        keychain.writeData(key: testKey, value: testData)
        XCTAssertEqual(keychain.readData(key: testKey), testData)
    }

    // MARK: - codable
    func testWriteCodable() {
        keychain.write(key: testKey, value: testCodable)
        let actualValue: FooBarStruct? = keychain.read(key: testKey)
        XCTAssertEqual(actualValue, testCodable)
    }

    func testReadCodable() {
        var actualValue: FooBarStruct?
        actualValue = keychain.read(key: testKey)
        XCTAssertNil(actualValue)
        keychain.write(key: testKey, value: testCodable)
        actualValue = keychain.read(key: testKey)
        XCTAssertEqual(actualValue, testCodable)
    }

    // MARK: - NSCoding
    func testWriteObject() {
        keychain.writeObject(key: testKey, value: testCoding)
        guard let actualValue = keychain.readObject(key: testKey) as? FooBarClass else {
            XCTFail("Can't cast to CodingClass")
            return
        }
        XCTAssertEqual(actualValue.foo, testCoding.foo)
        XCTAssertEqual(actualValue.bar, testCoding.bar)
    }

    func testReadObject() {
        XCTAssertNil(keychain.readObject(key: testKey))
        keychain.writeObject(key: testKey, value: testCoding)
        guard let actualValue = keychain.readObject(key: testKey) as? FooBarClass else {
            XCTFail("Can't cast to CodingClass")
            return
        }
        XCTAssertEqual(actualValue.foo, testCoding.foo)
        XCTAssertEqual(actualValue.bar, testCoding.bar)
    }

    func testWriteObjectWithDouble() {
        keychain.writeObject(key: testKey, value: testDouble)
        guard let actualValue = keychain.readObject(key: testKey) as? Double else {
            XCTFail("Can't cast to Double")
            return
        }
        XCTAssertEqual(actualValue, testDouble)
    }

    func testWriteObjectWithArray() {
        keychain.writeObject(key: testKey, value: testArray)
        guard let actualValue = keychain.readObject(key: testKey) as? [Double] else {
            XCTFail("Can't cast to Double")
            return
        }
        XCTAssertEqual(actualValue, testArray)
    }
}
