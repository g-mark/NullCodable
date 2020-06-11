import XCTest
@testable import NullCodable

final class NullCodableTests: XCTestCase {
    
    /// Test that `@NullCodable` applied to an attribute that doesn't have any `Codable`
    /// conformance will still compile & function properly.
    func test_noConformance() {
        // given
        struct Test {
            @NullCodable var a: String?
        }
        struct Container {
            @NullCodable var test: Test?
        }
        
        // when
        var container = Container(test: nil)
        
        // then
        XCTAssertNil(container.test)
        XCTAssertNil(container.test?.a)
        
        // when
        container.test = Test(a: nil)
        
        // then
        XCTAssertNotNil(container.test)
        XCTAssertNil(container.test?.a)
        
        // when
        container.test = Test(a: "a")
        
        // then
        XCTAssertNotNil(container.test)
        XCTAssertNotNil(container.test?.a)
        XCTAssertEqual(container.test?.a, "a")
    }
    
    /// Test that `@NullCodable` applied to a property type that has `Encodable` conformance
    /// properly encodes nil and non-nil values.
    func test_encodable() throws {
        // given
        struct Test: Encodable {
            @NullCodable var a: String?
        }
        struct Container: Encodable {
            @NullCodable var test: Test?
        }
        
        let encoder = JSONEncoder()
        
        // when
        var container = Container(test: nil)
        var data = try encoder.encode(container)
        var str = try XCTUnwrap(String(data: data, encoding: .utf8))
        
        // then
        XCTAssertEqual(str, "{\"test\":null}")
        
        // when
        container.test = Test(a: nil)
        data = try encoder.encode(container)
        str = try XCTUnwrap(String(data: data, encoding: .utf8))
        
        // then
        XCTAssertEqual(str, "{\"test\":{\"a\":null}}")
        
        // when
        container.test = Test(a: "a")
        data = try encoder.encode(container)
        str = try XCTUnwrap(String(data: data, encoding: .utf8))
        
        // then
        XCTAssertEqual(str, "{\"test\":{\"a\":\"a\"}}")
    }
    
    /// Test that `@NullCodable` applied to a property type that has `Decodable` conformance
    /// properly decodes `null` and non-nil values.
    func test_decodable() throws {
        // given
        struct Test: Decodable {
            @NullCodable var a: String?
            @NullCodable var b: Int?
        }
        struct Container: Decodable {
            @NullCodable var test: Test?
        }
        
        let decoder = JSONDecoder()
        
        // when
        var data = try XCTUnwrap("{\"test\":null}".data(using: .utf8))
        var container = try decoder.decode(Container.self, from: data)
        
        // then
        XCTAssertNil(container.test)
        
        // when
        data = try XCTUnwrap("{\"test\":{\"a\":null,\"b\":null}}".data(using: .utf8))
        container = try decoder.decode(Container.self, from: data)
        
        // then
        XCTAssertNotNil(container.test)
        XCTAssertNil(container.test?.a)
        XCTAssertNil(container.test?.b)
        
        // when
        data = try XCTUnwrap("{\"test\":{\"a\":\"a\",\"b\":42}}".data(using: .utf8))
        container = try decoder.decode(Container.self, from: data)
        
        // then
        XCTAssertEqual(container.test?.a, "a")
        XCTAssertEqual(container.test?.b, 42)
    }
    
    static var allTests = [
        ("test_noConformance", test_noConformance),
        ("test_encodable", test_encodable),
        ("test_decodable", test_decodable),
    ]
    
}
