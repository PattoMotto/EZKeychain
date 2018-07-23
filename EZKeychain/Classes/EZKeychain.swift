import Security

@objc public protocol EZKeychainObjc {
    func readObject(_ key: String) -> Any?
    @discardableResult func writeObject(key: String, value: Any) -> Bool
    func readData(_ key: String) -> Data?
    @discardableResult func writeData(key: String, value: Data) -> Bool
    func readString(_ key: String) -> String?
    @discardableResult func writeString(key: String, value: String) -> Bool
    func readPList(_ key: String) -> Any?
    @discardableResult func writePList(key: String, value: Any) -> Bool
    @discardableResult func clear(_ key: String) -> Bool
}

public protocol EZKeychainGeneric {
    func read<T>(_ key: String) -> T? where T : Codable
    func write<T>(key: String, value: T) -> Bool where T : Codable
    func clear(_ key: String) -> Bool
}

@objc public enum EZKeychainAccessible: Int {
    case whenUnlocked
    case afterFirstUnlock
    case accessibleAlways
    case whenPasscodeSetThisDeviceOnly
    case whenUnlockedThisDeviceOnly
    case afterFirstUnlockThisDeviceOnly
    case alwaysThisDeviceOnly

    func cfString() -> CFString {
        switch self {
        case .whenUnlocked:
            return kSecAttrAccessibleWhenUnlocked
        case .afterFirstUnlock:
            return kSecAttrAccessibleAfterFirstUnlock
        case .accessibleAlways:
            return kSecAttrAccessibleAlways
        case .whenPasscodeSetThisDeviceOnly:
            return kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly
        case .whenUnlockedThisDeviceOnly:
            return kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        case .afterFirstUnlockThisDeviceOnly:
            return kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        case .alwaysThisDeviceOnly:
            return kSecAttrAccessibleAlwaysThisDeviceOnly
        }
    }
}

@objc public final class EZKeychain: NSObject {

    private static let bunbleId: String = Bundle.main.bundleIdentifier!

    fileprivate let service: String
    fileprivate let accessible: EZKeychainAccessible
    fileprivate let accessGroup: String?

    @objc public static let shared: EZKeychain = EZKeychain()

    @objc public override convenience init() {
        self.init(
            service: EZKeychain.bunbleId,
            accessible: .afterFirstUnlock,
            accessGroup: nil
        )
    }

    @objc public convenience init(service: String,
                                  accessible: EZKeychainAccessible) {
        self.init(
            service: service,
            accessible: accessible,
            accessGroup: nil
        )
    }

    @objc public init(service: String,
                      accessible: EZKeychainAccessible,
                      accessGroup: String?) {
        self.service = service
        self.accessible = accessible
        self.accessGroup = accessGroup
        super.init()
    }

    private func queryForRead(_ key: String) -> [String: Any] {
        var query: [String: Any] = [kSecAttrService as String: service,
                                    kSecClass as String: kSecClassGenericPassword,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true,
                                    kSecAttrAccount as String: key]
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }
        return query
    }

    private func queryForWrite(key: String, value: Data) -> [String: Any] {
        var query: [String: Any] = [kSecAttrService as String: service,
                                    kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccessible as String: accessible.cfString(),
                                    kSecAttrAccount as String: key,
                                    kSecValueData as String: value]
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }
        return query
    }

    private func queryForSearchUpdate(_ key: String) -> [String: Any] {
        var query: [String: Any] = [kSecAttrService as String: service,
                                    kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: key]
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }
        return query
    }

    private func queryForUpdate(key: String, value: Data) -> [String: Any] {
        return [kSecValueData as String: value,
                kSecAttrAccessible as String: accessible.cfString()]
    }

    fileprivate func commonRead(_ key: String) -> Data? {
        var item: CFTypeRef?
        let status = SecItemCopyMatching(
            queryForRead(key) as CFDictionary,
            &item)
        guard status == errSecSuccess else { return nil }
        guard status != errSecItemNotFound else { return nil }
        guard let existingItem = item as? [String : Any],
            let data = existingItem[kSecValueData as String] as? Data else { return nil }
        return data
    }

    fileprivate func commonWrite(key: String, value: Data) -> Bool {
        var status: OSStatus
        if commonRead(key) != nil {
            status = SecItemUpdate(
                queryForSearchUpdate(key) as CFDictionary,
                queryForUpdate(key: key, value: value) as CFDictionary
            )
        } else {
            status = SecItemAdd(
                queryForWrite(key: key, value: value) as CFDictionary,
                nil
            )
        }
        guard status == errSecSuccess else { return false }
        return true
    }
}

extension EZKeychain: EZKeychainGeneric {
    public func read<T>(_ key: String) -> T? where T : Codable {
        if T.self is String.Type {
            return readString(key) as? T
        } else {
            guard let data = commonRead(key),
                let decodedData = try? JSONDecoder().decode(T.self, from: data) as T else {
                    return nil
            }
            return decodedData
        }
    }

    @discardableResult public func write<T>(key: String, value: T) -> Bool where T : Codable {
        if let stringValue = value as? String {
            return writeString(key: key, value: stringValue)
        } else if let data = try? JSONEncoder().encode(value) {
            return commonWrite(key: key, value: data)
        }
        return false
    }

    @discardableResult public func clear(_ key: String) -> Bool {
        var query: [String: Any] = [kSecAttrService as String: service,
                                    kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccessible as String: accessible.cfString(),
                                    kSecAttrAccount as String: key]
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess else { return false }
        return true
    }
}

extension EZKeychain: EZKeychainObjc {
    public func readObject(_ key: String) -> Any? {
        guard let data = commonRead(key) else { return nil }
        return NSKeyedUnarchiver.unarchiveObject(with: data)
    }

    @discardableResult public func writeObject(key: String, value: Any) -> Bool {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: value)
        return commonWrite(
            key: key,
            value: encodedData
        )
    }

    public func readData(_ key: String) -> Data? {
        return commonRead(key)
    }

    @discardableResult public func writeData(key: String, value: Data) -> Bool {
        return commonWrite(
            key: key,
            value: value
        )
    }

    public func readString(_ key: String) -> String? {
        guard let data = commonRead(key) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    @discardableResult public func writeString(key: String, value: String) -> Bool {
        guard let encodedData = value.data(using: .utf8) else { return false }
        return commonWrite(
            key: key,
            value: encodedData
        )
    }

    public func readPList(_ key: String) -> Any? {
        guard let data = commonRead(key) else { return nil }
        var format = PropertyListSerialization.PropertyListFormat.binary
        return try? PropertyListSerialization.propertyList(
            from: data,
            options: .mutableContainers,
            format: &format
        )
    }

    @discardableResult public func writePList(key: String, value: Any) -> Bool {
        guard let encodedData = try? PropertyListSerialization.data(
            fromPropertyList: value,
            format: .binary,
            options: 0
            ) else { return false }
        return commonWrite(
            key: key,
            value: encodedData
        )
    }
}
