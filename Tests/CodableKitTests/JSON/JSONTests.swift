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
        XCTAssertEqual(JSON.string("string"), "string")
        XCTAssertEqual(JSON.number(42), 42)
        XCTAssertEqual(JSON.number(42), 42.0)
        XCTAssertEqual(JSON.object(["key": "value"]), ["key": "value"])
        XCTAssertEqual(JSON.array([42]), [42])
        XCTAssertEqual(JSON.true, true)
        XCTAssertEqual(JSON.false, false)
        XCTAssertEqual(JSON.null, nil)
    }

    func testProperties() {
        let string = "string"
        let number: NSNumber = 42
        do {
            let json = JSON(string)
            XCTAssertEqual(json.string, string)
        }
        do {
            let json = JSON(number)
            XCTAssertEqual(json.number, number)
            XCTAssertNil(json.string)
        }
        do {
            let object = [string: JSON(number)]
            let json = JSON(object)
            XCTAssertEqual(json.object, object)
            XCTAssertNil(json.number)
        }
        do {
            let array = [JSON(string), JSON(number)]
            let json = JSON(array)
            XCTAssertEqual(json.array, array)
            XCTAssertNil(json.object)
        }
        do {
            let json = JSON.true
            XCTAssertEqual(json.bool, true)
            XCTAssertNil(json.array)
        }
        do {
            let json = JSON.false
            XCTAssertEqual(json.bool, false)
            XCTAssertFalse(json.isNull)
        }
        do {
            let json = JSON.null
            XCTAssertTrue(json.isNull)
            XCTAssertNil(json.bool)
        }
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
