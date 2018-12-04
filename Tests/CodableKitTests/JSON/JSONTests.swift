//
//  JSONTests.swift
//  CodableKitTests
//
//  Created by 李孛 on 2018/6/13.
//

import XCTest
@testable import CodableKit

final class JSONTests: XCTestCase {
    func testInitializers() {
        let object: [String: JSON] = ["null": .null]
        let dictionary: [String: Any] = ["null": NSNull()]
        let array: [JSON] = [.null]

        XCTAssertEqual(JSON(object), .object(object))
        XCTAssertNil(JSON(["nsobject": NSObject()]))
        XCTAssertEqual(JSON(dictionary), .object(object))
        XCTAssertEqual(JSON(array), .array(array))
        XCTAssertNil(JSON([NSObject()]))
        XCTAssertEqual(JSON([NSNull()]), .array(array))
        XCTAssertEqual(JSON(NSNumber(value: true)), .true)
        XCTAssertEqual(JSON(NSNumber(value: 42)), .number(42))
        XCTAssertEqual(JSON(42 as Int), .number(42))
        XCTAssertEqual(JSON(42 as Int8), .number(42))
        XCTAssertEqual(JSON(42 as Int16), .number(42))
        XCTAssertEqual(JSON(42 as Int32), .number(42))
        XCTAssertEqual(JSON(42 as Int64), .number(42))
        XCTAssertEqual(JSON(42 as UInt), .number(42))
        XCTAssertEqual(JSON(42 as UInt8), .number(42))
        XCTAssertEqual(JSON(42 as UInt16), .number(42))
        XCTAssertEqual(JSON(42 as UInt32), .number(42))
        XCTAssertEqual(JSON(42 as UInt64), .number(42))
        XCTAssertEqual(JSON(42 as Double), .number(42))
        XCTAssertEqual(JSON(42 as Float), .number(42))
        XCTAssertEqual(JSON("string"), .string("string"))
        XCTAssertEqual(JSON(true), .true)
        XCTAssertEqual(JSON(false), .false)
        XCTAssertEqual(JSON(NSNull()), .null)
        XCTAssertEqual(JSON(object as Any), .object(object))
        XCTAssertEqual(JSON(dictionary as Any), .object(object))
        XCTAssertEqual(JSON(array as Any), .array(array))
        XCTAssertEqual(JSON(42 as Any), .number(42))
        XCTAssertEqual(JSON("string" as Any), .string("string"))
    }

    func testLiterals() {
        XCTAssertEqual(JSON.object(["key": "value"]), ["key": "value"])
        XCTAssertEqual(JSON.array([42]), [42])
        XCTAssertEqual(JSON.number(42), 42)
        XCTAssertEqual(JSON.number(42), 42.0)
        XCTAssertEqual(JSON.string("string"), "string")
        XCTAssertEqual(JSON.true, true)
        XCTAssertEqual(JSON.false, false)
        XCTAssertEqual(JSON.null, nil)
    }

    func testSubscripts() {
        do {
            let json: JSON = ["key": "value"]
            XCTAssertTrue(json.isObject)
            XCTAssertEqual(json["key"], "value")
            XCTAssertFalse(json.isArray)
            XCTAssertNil(json[0])
        }
        do {
            let json: JSON = [42]
            XCTAssertTrue(json.isArray)
            XCTAssertEqual(json[0], 42)
            XCTAssertFalse(json.isObject)
            XCTAssertNil(json["key"])
        }
    }

    func testCustomStringConvertible() {
        let string = "string"
        let number = 42
        let object = [string: JSON(number)]
        let array = [JSON(string), JSON(number), JSON(object)]
        XCTAssertEqual("\(JSON(string))", "string(\"\(string)\")")
        XCTAssertEqual("\(JSON(number))", "number(\(number))")
        XCTAssertEqual("\(JSON(object))", "object(\(object))")
        XCTAssertEqual("\(JSON(array))", "array(\(array))")
        XCTAssertEqual("\(JSON.true)", "true")
        XCTAssertEqual("\(JSON.false)", "false")
        XCTAssertEqual("\(JSON.null)", "null")
    }

    func testSerialization() {
        let data = """
            {
                "string": "string",
                "number": 42
            }
            """
            .data(using: .utf8)!
        let json = try! JSON.Serialization.json(with: data)
        XCTAssertEqual(json, ["string": "string", "number": 42])
    }
}

final class JSONPropertiesTests: XCTestCase {
    func testObject() {
        let json: JSON = ["null": nil]

        XCTAssertTrue(json.isObject)
        XCTAssertFalse(json.isArray)
        XCTAssertFalse(json.isNumber)
        XCTAssertFalse(json.isString)
        XCTAssertFalse(json.isTrue)
        XCTAssertFalse(json.isFalse)
        XCTAssertFalse(json.isNull)

        XCTAssertEqual(json.object, ["null": nil])
        XCTAssertNil(json.array)
        XCTAssertNil(json.number)
        XCTAssertNil(json.string)
    }

    func testArray() {
        let json: JSON = [nil]

        XCTAssertTrue(json.isArray)
        XCTAssertFalse(json.isObject)
        XCTAssertFalse(json.isNumber)
        XCTAssertFalse(json.isString)
        XCTAssertFalse(json.isTrue)
        XCTAssertFalse(json.isFalse)
        XCTAssertFalse(json.isNull)

        XCTAssertEqual(json.array, [nil])
        XCTAssertNil(json.object)
        XCTAssertNil(json.number)
        XCTAssertNil(json.string)
    }

    func testNumber() {
        let json: JSON = 42

        XCTAssertTrue(json.isNumber)
        XCTAssertFalse(json.isObject)
        XCTAssertFalse(json.isArray)
        XCTAssertFalse(json.isString)
        XCTAssertFalse(json.isTrue)
        XCTAssertFalse(json.isFalse)
        XCTAssertFalse(json.isNull)

        XCTAssertEqual(json.number, 42)
        XCTAssertNil(json.object)
        XCTAssertNil(json.array)
        XCTAssertNil(json.string)
    }

    func testString() {
        let json: JSON = "string"

        XCTAssertTrue(json.isString)
        XCTAssertFalse(json.isObject)
        XCTAssertFalse(json.isArray)
        XCTAssertFalse(json.isNumber)
        XCTAssertFalse(json.isTrue)
        XCTAssertFalse(json.isFalse)
        XCTAssertFalse(json.isNull)

        XCTAssertEqual(json.string, "string")
        XCTAssertNil(json.object)
        XCTAssertNil(json.array)
        XCTAssertNil(json.number)
    }

    func testTrue() {
        let json: JSON = true

        XCTAssertTrue(json.isTrue)
        XCTAssertFalse(json.isObject)
        XCTAssertFalse(json.isArray)
        XCTAssertFalse(json.isNumber)
        XCTAssertFalse(json.isString)
        XCTAssertFalse(json.isFalse)
        XCTAssertFalse(json.isNull)

        XCTAssertNil(json.object)
        XCTAssertNil(json.array)
        XCTAssertNil(json.number)
        XCTAssertNil(json.string)
    }

    func testFalse() {
        let json: JSON = false

        XCTAssertTrue(json.isFalse)
        XCTAssertFalse(json.isObject)
        XCTAssertFalse(json.isArray)
        XCTAssertFalse(json.isNumber)
        XCTAssertFalse(json.isString)
        XCTAssertFalse(json.isTrue)
        XCTAssertFalse(json.isNull)

        XCTAssertNil(json.object)
        XCTAssertNil(json.array)
        XCTAssertNil(json.number)
        XCTAssertNil(json.string)
    }

    func testNull() {
        let json: JSON = nil

        XCTAssertTrue(json.isNull)
        XCTAssertFalse(json.isObject)
        XCTAssertFalse(json.isArray)
        XCTAssertFalse(json.isNumber)
        XCTAssertFalse(json.isString)
        XCTAssertFalse(json.isTrue)
        XCTAssertFalse(json.isFalse)

        XCTAssertNil(json.object)
        XCTAssertNil(json.array)
        XCTAssertNil(json.number)
        XCTAssertNil(json.string)
    }
}
