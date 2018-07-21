import EZKeychain

class ViewController: UIViewController {

    private let keyString = "StringKey"
    private let keyData = "DataKey"
    private let keyObject = "ObjectKey"
    private let keyCodable = "CodableKey"
    private var keychain: EZKeychain?

    override func viewDidLoad() {
        super.viewDidLoad()
        keychain = EZKeychain.shared

        writeKeychain()
        readKeychain()

        // update
        writeKeychain()

        clearKeychain()
        readKeychain()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController {

    fileprivate func writeKeychain() {
        guard let keychain = keychain else { return }
        keychain.writeString(key: keyString, value: "Simple string")
        keychain.writeData(key: keyData, value: NSKeyedArchiver.archivedData(withRootObject: [111.11, 999.99]))
        keychain.writeObject(key: keyObject, value: ["Foo": 111.11])
        keychain.write(key: keyCodable, value: FooBarStruct(foo: "Foo", bar: 11))
    }

    fileprivate func readKeychain() {
        guard let keychain = keychain else { return }
        print(keyString, keychain.readString(keyString))
        print(keyData, keychain.readData(keyData))
        print(keyObject, keychain.readObject(keyObject))
        let doubleValue:FooBarStruct? = keychain.read(keyCodable)
        print(keyCodable, doubleValue)
    }

    fileprivate func clearKeychain() {
        guard let keychain = keychain else { return }
        keychain.clear(keyString)
        keychain.clear(keyData)
        keychain.clear(keyObject)
        keychain.clear(keyCodable)
    }
}
