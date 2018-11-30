//
//  AnyCodingKey+KeyPath.swift
//  CodableKit
//
//  Created by leave on 2018/11/27.
//

import Foundation

extension KeyedDecodingContainerProtocol where Key == AnyCodingKey {
    
    /// Decodes a value of the given type for the given key, without specific type.
    ///
    /// Keypath is supported: e.g. `value1 = try container.decode("b0.b1.value")`
    ///
    /// - Parameters:
    ///   - key: the keyPath
    ///   - useKeyPath: If the key contain "dot" naturaly, set this to ture to treat as one whole key.
    /// - Throws: same to decode<T>(_ type:forKey:)
    ///
    public func decode<T: Decodable>(_ key: Key, useKeyPath: Bool = true) throws -> T {
        let paths = key.keyPaths()
        if useKeyPath == false || paths.count <= 1 {
            return try self.decode(T.self, forKey: key)
        }

        let pathKeys = Array(paths[0..<paths.count-1])
        let nameKey = paths.last!
        let container = try self.nestedContainer(for: pathKeys)
        return try container.decode(T.self, forKey: nameKey)
    }
}

extension KeyedDecodingContainerProtocol where Key == AnyCodingKey {
    
    public func nestedContainer(forKey key: Key, useKeyPath: Bool = true) throws -> KeyedDecodingContainer<AnyCodingKey> {
        if !useKeyPath {
            return try self.nestedContainer(keyedBy: AnyCodingKey.self, forKey: key)
        }
        return try nestedContainer(for: key.keyPaths())
    }
    
    fileprivate func nestedContainer(for keyPaths:[Key]) throws -> KeyedDecodingContainer<AnyCodingKey> {
        assert(keyPaths.count > 0)
        var container = try self.nestedContainer(keyedBy: AnyCodingKey.self, forKey: keyPaths[0])
        for path in keyPaths[1..<keyPaths.count] {
            container = try container.nestedContainer(keyedBy: AnyCodingKey.self, forKey: path)
        }
        return container
    }
    
}

extension KeyedEncodingContainerProtocol where Key == AnyCodingKey {
    
    public mutating func nestedContainer(forKey key: Key, useKeyPath: Bool = true) -> KeyedEncodingContainer<AnyCodingKey> {
        if !useKeyPath {
            return nestedContainer(keyedBy: AnyCodingKey.self, forKey: key)
        }
        return nestedContainer(for: key.keyPaths())
    }
    
    fileprivate mutating func nestedContainer(for keyPaths: [Key]) -> KeyedEncodingContainer<AnyCodingKey> {
        assert(keyPaths.count > 0)
        var container = self.nestedContainer(keyedBy: AnyCodingKey.self, forKey: keyPaths[0])
        for path in keyPaths[1..<keyPaths.count] {
            container = container.nestedContainer(keyedBy: AnyCodingKey.self, forKey: path)
        }
        return container
    }
}


extension AnyCodingKey {

    /// Split the Key by "."
    fileprivate func keyPaths() -> [AnyCodingKey] {
        let keys = stringValue.components(separatedBy: ".").map( AnyCodingKey.init(stringValue:) )
        assert(keys.count > 0)
        return keys
    }
}
