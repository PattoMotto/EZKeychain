//Pat
import EZKeychain

final class KeychainExample {


    private let keyString = "StringKey"
    private let keyData = "DataKey"
    private let keyObject = "ObjectKey"
    private let keyCodable = "CodableKey"
    private let keychain: EZKeychain

    init() {
        keychain = EZKeychain.shared
        write()
        read()
//        update
        write()
        clear()
        read()
    }

    func read() {
        print(keyString, keychain.readString(key: keyString))
        print(keyData, keychain.readData(key: keyData))
        print(keyObject, keychain.readObject(key: keyObject))
        let doubleValue:FooBarStruct? = keychain.read(key: keyCodable)
        print(keyCodable, doubleValue)
    }
    func write() {
        keychain.writeString(key: keyString, value: "Simple string")
        keychain.writeData(key: keyData, value: NSKeyedArchiver.archivedData(withRootObject: [111.11, 999.99]))
        keychain.writeObject(key: keyObject, value: ["Foo": 111.11])
        keychain.write(key: keyCodable, value: FooBarStruct(foo: "Foo", bar: 11))
    }
    func clear() {
        keychain.clear(key: keyString)
        keychain.clear(key: keyData)
        keychain.clear(key: keyObject)
        keychain.clear(key: keyCodable)
    }
}
