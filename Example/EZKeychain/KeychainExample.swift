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
        print(keyString, keychain.readString(keyString))
        print(keyData, keychain.readData(keyData))
        print(keyObject, keychain.readObject(keyObject))
        let doubleValue:FooBarStruct? = keychain.read(keyCodable)
        print(keyCodable, doubleValue)
    }
    func write() {
        keychain.writeString(key: keyString, value: "Simple string")
        keychain.writeData(key: keyData, value: NSKeyedArchiver.archivedData(withRootObject: [111.11, 999.99]))
        keychain.writeObject(key: keyObject, value: ["Foo": 111.11])
        keychain.write(key: keyCodable, value: FooBarStruct(foo: "Foo", bar: 11))
    }
    func clear() {
        keychain.clear(keyString)
        keychain.clear(keyData)
        keychain.clear(keyObject)
        keychain.clear(keyCodable)
    }
}
