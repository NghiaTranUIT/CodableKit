//
//  JSON.swift
//  CodableKit
//
//  Created by 李孛 on 2018/6/15.
//

import Foundation

/// JSON value.
///
/// [https://json.org](https://json.org)
public enum JSON: Equatable {
    case object([String: JSON])
    case array([JSON])
    case number(NSNumber)
    case string(String)
    case `true`
    case `false`
    case null
}

// MARK: - Initializers

extension JSON {
    public init(_ object: [String: JSON]) { self = .object(object) }

    public init?(_ dictionary: [String: Any]) {
        var object: [String: JSON] = [:]
        for (key, value) in dictionary {
            guard let json = JSON(value) else {
                return nil
            }
            object[key] = json
        }
        self.init(object)
    }

    public init(_ array: [JSON]) { self = .array(array) }

    public init?(_ array: [Any]) {
        var jsonArray: [JSON] = []
        for element in array {
            guard let json = JSON(element) else {
                return nil
            }
            jsonArray.append(json)
        }
        self.init(jsonArray)
    }

    public init(_ number: NSNumber) {
        if type(of: number) == NSNumber.typeOfBooleanNumber {
            self.init(number.boolValue)
        } else {
            self = .number(number)
        }
    }

    public init(_ value: Int) { self = .number(NSNumber(value: value)) }
    public init(_ value: Int8) { self = .number(NSNumber(value: value)) }
    public init(_ value: Int16) { self = .number(NSNumber(value: value)) }
    public init(_ value: Int32) { self = .number(NSNumber(value: value)) }
    public init(_ value: Int64) { self = .number(NSNumber(value: value)) }
    public init(_ value: UInt) { self = .number(NSNumber(value: value)) }
    public init(_ value: UInt8) { self = .number(NSNumber(value: value)) }
    public init(_ value: UInt16) { self = .number(NSNumber(value: value)) }
    public init(_ value: UInt32) { self = .number(NSNumber(value: value)) }
    public init(_ value: UInt64) { self = .number(NSNumber(value: value)) }
    public init(_ value: Double) { self = .number(NSNumber(value: value)) }
    public init(_ value: Float) { self = .number(NSNumber(value: value)) }

    public init(_ string: String) { self = .string(string) }

    public init(_ bool: Bool) { self = bool ? .true : . false }

    public init(_ null: NSNull) { self = .null }

    public init?(_ value: Any) {
        switch value {
        case let object as [String: JSON]:
            self.init(object)
        case let dictionary as [String: Any]:
            self.init(dictionary)
        case let array as [JSON]:
            self.init(array)
        case let array as [Any]:
            self.init(array)
        case let number as NSNumber:
            self.init(number)
        case let string as String:
            self.init(string)
        case let null as NSNull:
            self.init(null)
        default:
            return nil
        }
    }
}

extension NSNumber {
    fileprivate static let typeOfBooleanNumber = type(of: NSNumber(value: true))
}

// MARK: - Literals

extension JSON: ExpressibleByDictionaryLiteral {}
extension JSON: ExpressibleByArrayLiteral {}
extension JSON: ExpressibleByIntegerLiteral {}
extension JSON: ExpressibleByFloatLiteral {}
extension JSON: ExpressibleByStringLiteral {}
extension JSON: ExpressibleByBooleanLiteral {}
extension JSON: ExpressibleByNilLiteral {}

extension JSON {
    public init(dictionaryLiteral elements: (String, JSON)...) { self.init(Dictionary(uniqueKeysWithValues: elements)) }
    public init(arrayLiteral elements: JSON...) { self.init(elements) }
    public init(integerLiteral value: Int) { self.init(value) }
    public init(floatLiteral value: Double) { self.init(value) }
    public init(stringLiteral value: String) { self.init(value) }
    public init(booleanLiteral value: Bool) { self.init(value) }
    public init(nilLiteral: ()) { self = .null }
}

// MARK: - Properties

extension JSON {
    public var isObject: Bool {
        switch self {
        case .object:
            return true
        default:
            return false
        }
    }

    public var object: [String: JSON]? {
        switch self {
        case .object(let object):
            return object
        default:
            return nil
        }
    }

    public var isArray: Bool {
        switch self {
        case .array:
            return true
        default:
            return false
        }
    }

    public var array: [JSON]? {
        switch self {
        case .array(let array):
            return array
        default:
            return nil
        }
    }

    public var isNumber: Bool {
        switch self {
        case .number:
            return true
        default:
            return false
        }
    }

    public var number: NSNumber? {
        switch self {
        case .number(let number):
            return number
        default:
            return nil
        }
    }

    public var isString: Bool {
        switch self {
        case .string:
            return true
        default:
            return false
        }
    }

    public var string: String? {
        switch self {
        case .string(let string):
            return string
        default:
            return nil
        }
    }

    public var isTrue: Bool {
        switch self {
        case .true:
            return true
        default:
            return false
        }
    }

    public var isFalse: Bool {
        switch self {
        case .false:
            return true
        default:
            return false
        }
    }

    public var isNull: Bool {
        switch self {
        case .null:
            return true
        default:
            return false
        }
    }
}

// MARK: - Subscripts

extension JSON {
    public subscript(key: String) -> JSON? {
        switch self {
        case .object(let object):
            return object[key]
        default:
            return nil
        }
    }

    public subscript(index: Int) -> JSON? {
        switch self {
        case .array(let array):
            return array[index]
        default:
            return nil
        }
    }
}

// MARK: - CustomStringConvertible

extension JSON: CustomStringConvertible {
    public var description: String {
        switch self {
        case .string(let string):
            return "string(\"\(string)\")"
        case .number(let number):
            return "number(\(number))"
        case .object(let object):
            return "object(\(object))"
        case .array(let array):
            return "array(\(array))"
        case .true:
            return "true"
        case .false:
            return "false"
        case .null:
            return "null"
        }
    }
}
