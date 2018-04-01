import Foundation

// JSONObjectEncoder is a condensed clone of Swift's JSONEncoder that produces NSObject representation of JSON objects, instead of serialized NSData
// See https://github.com/apple/swift/blob/master/stdlib/public/SDK/Foundation/JSONEncoder.swift
// NOTE: Error handling was vastly simplified to reduce complexity

enum JSONObjectEncodingError: Error {
    case noEncodedValue
    case unsupportedDataValue
    case unsupportedFloatValue
}

public class JSONObjectEncoder : Encoder, CodingPathIgnoring {
    
    fileprivate var json : NSObject?
    
    public let userInfo: [CodingUserInfoKey : Any] = [:]
    
    public func container<Key>(keyedBy: Key.Type) -> KeyedEncodingContainer<Key> {
        let container = JSONObjectKeyedContainer<Key>()
        json = container.dictionary
        return KeyedEncodingContainer(container)
    }
    
    public func unkeyedContainer() -> UnkeyedEncodingContainer {
        let container = JSONObjectUnkeyedContainer()
        json = container.array
        return container
    }
    
    public func singleValueContainer() -> SingleValueEncodingContainer {
        return self
    }
    
    public func retrieveEncodedObject() throws -> NSObject {
        if let json = json {
            return json
        } else {
            throw JSONObjectEncodingError.noEncodedValue
        }
    }
}

fileprivate struct JSONObjectKeyedContainer<K : CodingKey> : KeyedEncodingContainerProtocol, CodingPathIgnoring {
    
    typealias Key = K
    
    public let dictionary: NSMutableDictionary
    
    init(dictionary: NSMutableDictionary = NSMutableDictionary()) {
        self.dictionary = dictionary
    }
    
    public mutating func encodeNil(forKey key: Key) throws { dictionary[key.stringValue] = NSNull() }
    public mutating func encode(_ value: Bool, forKey key: Key) throws { dictionary[key.stringValue] = JSONBoxer.box(value) }
    public mutating func encode(_ value: Int, forKey key: Key) throws { dictionary[key.stringValue] = JSONBoxer.box(value) }
    public mutating func encode(_ value: Int8, forKey key: Key) throws { dictionary[key.stringValue] = JSONBoxer.box(value) }
    public mutating func encode(_ value: Int16, forKey key: Key) throws { dictionary[key.stringValue] = JSONBoxer.box(value) }
    public mutating func encode(_ value: Int32, forKey key: Key) throws { dictionary[key.stringValue] = JSONBoxer.box(value) }
    public mutating func encode(_ value: Int64, forKey key: Key) throws { dictionary[key.stringValue] = JSONBoxer.box(value) }
    public mutating func encode(_ value: UInt, forKey key: Key) throws { dictionary[key.stringValue] = JSONBoxer.box(value) }
    public mutating func encode(_ value: UInt8, forKey key: Key) throws { dictionary[key.stringValue] = JSONBoxer.box(value) }
    public mutating func encode(_ value: UInt16, forKey key: Key) throws { dictionary[key.stringValue] = JSONBoxer.box(value) }
    public mutating func encode(_ value: UInt32, forKey key: Key) throws { dictionary[key.stringValue] = JSONBoxer.box(value) }
    public mutating func encode(_ value: UInt64, forKey key: Key) throws { dictionary[key.stringValue] = JSONBoxer.box(value) }
    public mutating func encode(_ value: String, forKey key: Key) throws { dictionary[key.stringValue] = JSONBoxer.box(value) }
    public mutating func encode(_ value: Float, forKey key: Key) throws { dictionary[key.stringValue] = try JSONBoxer.box(value) }
    public mutating func encode(_ value: Double, forKey key: Key) throws { dictionary[key.stringValue] = try JSONBoxer.box(value) }
    public mutating func encode<T : Encodable>(_ value: T, forKey key: Key) throws { dictionary[key.stringValue] = try JSONBoxer.box(value) }
    
    public mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> {
        let container = JSONObjectKeyedContainer<NestedKey>()
        dictionary[key.stringValue] = container.dictionary
        return KeyedEncodingContainer(container)
    }
    
    public mutating func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        let container = JSONObjectUnkeyedContainer()
        dictionary[key.stringValue] = container.array
        return container
    }
    
    public mutating func superEncoder() -> Encoder {
        return WrappingEncoder(container: .keyed(dictionary: dictionary))
    }
    
    public mutating func superEncoder(forKey key: Key) -> Encoder {
        return self.superEncoder()
    }
}

fileprivate struct JSONObjectUnkeyedContainer : UnkeyedEncodingContainer, CodingPathIgnoring {
    
    public let array: NSMutableArray
    public var count: Int { return self.array.count }
    
    init(array: NSMutableArray = NSMutableArray()) {
        self.array = array
    }
    
    public mutating func encodeNil()             throws { array.add(NSNull()) }
    public mutating func encode(_ value: Bool)   throws { array.add(JSONBoxer.box(value)) }
    public mutating func encode(_ value: Int)    throws { array.add(JSONBoxer.box(value)) }
    public mutating func encode(_ value: Int8)   throws { array.add(JSONBoxer.box(value)) }
    public mutating func encode(_ value: Int16)  throws { array.add(JSONBoxer.box(value)) }
    public mutating func encode(_ value: Int32)  throws { array.add(JSONBoxer.box(value)) }
    public mutating func encode(_ value: Int64)  throws { array.add(JSONBoxer.box(value)) }
    public mutating func encode(_ value: UInt)   throws { array.add(JSONBoxer.box(value)) }
    public mutating func encode(_ value: UInt8)  throws { array.add(JSONBoxer.box(value)) }
    public mutating func encode(_ value: UInt16) throws { array.add(JSONBoxer.box(value)) }
    public mutating func encode(_ value: UInt32) throws { array.add(JSONBoxer.box(value)) }
    public mutating func encode(_ value: UInt64) throws { array.add(JSONBoxer.box(value)) }
    public mutating func encode(_ value: String) throws { array.add(JSONBoxer.box(value)) }
    public mutating func encode(_ value: Float)  throws { array.add(try JSONBoxer.box(value)) }
    public mutating func encode(_ value: Double) throws { array.add(try JSONBoxer.box(value)) }
    public mutating func encode<T : Encodable>(_ value: T) throws { array.add(try JSONBoxer.box(value)) }
    
    public mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> {
        let container = JSONObjectKeyedContainer<NestedKey>()
        array.add(container.dictionary)
        return KeyedEncodingContainer(container)
    }
    
    public mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        let container = JSONObjectUnkeyedContainer()
        array.add(container.array)
        return container
    }
    
    public mutating func superEncoder() -> Encoder {
        return WrappingEncoder(container: .unkeyed(array: array))
    }
}

extension JSONObjectEncoder : SingleValueEncodingContainer {
    
    public func encodeNil() throws { json = NSNull() }
    public func encode(_ value: Bool) throws { json = JSONBoxer.box(value) }
    public func encode(_ value: Int) throws { json = JSONBoxer.box(value) }
    public func encode(_ value: Int8) throws { json = JSONBoxer.box(value) }
    public func encode(_ value: Int16) throws { json = JSONBoxer.box(value) }
    public func encode(_ value: Int32) throws { json = JSONBoxer.box(value) }
    public func encode(_ value: Int64) throws { json = JSONBoxer.box(value) }
    public func encode(_ value: UInt) throws { json = JSONBoxer.box(value) }
    public func encode(_ value: UInt8) throws { json = JSONBoxer.box(value) }
    public func encode(_ value: UInt16) throws { json = JSONBoxer.box(value) }
    public func encode(_ value: UInt32) throws { json = JSONBoxer.box(value) }
    public func encode(_ value: UInt64) throws { json = JSONBoxer.box(value) }
    public func encode(_ value: String) throws { json = JSONBoxer.box(value) }
    public func encode(_ value: Float) throws { json = try JSONBoxer.box(value) }
    public func encode(_ value: Double) throws { json = try JSONBoxer.box(value) }
    public func encode<T : Encodable>(_ value: T) throws { json = try JSONBoxer.box(value) }
}

fileprivate class WrappingEncoder : JSONObjectEncoder {
    
    enum Container {
        case unkeyed(array: NSMutableArray)
        case keyed(dictionary: NSMutableDictionary)
    }
    
    fileprivate let container: Container
    
    init(container: Container) {
        self.container = container
        super.init()
        
        switch container {
        case .keyed(let dictionary):
            self.json = dictionary
        case .unkeyed(let array):
            self.json = array
        }
    }
    
    override public func container<Key>(keyedBy: Key.Type) -> KeyedEncodingContainer<Key> {
        switch container {
        case .keyed(let dictionary):
            let container = JSONObjectKeyedContainer<Key>(dictionary: dictionary)
            return KeyedEncodingContainer(container)
        default:
            return super.container(keyedBy: keyedBy) // unexpected case, fallback to decoupled container
        }
    }
    
    override public func unkeyedContainer() -> UnkeyedEncodingContainer {
        switch container {
        case .unkeyed(let array):
            return JSONObjectUnkeyedContainer(array: array)
        default:
            return super.unkeyedContainer() // unexpected case, fallback to decoupled container
        }
    }
}

fileprivate class JSONBoxer {
    
    static func box(_ value: Bool)   -> NSObject { return NSNumber(value: value) }
    static func box(_ value: Int)    -> NSObject { return NSNumber(value: value) }
    static func box(_ value: Int8)   -> NSObject { return NSNumber(value: value) }
    static func box(_ value: Int16)  -> NSObject { return NSNumber(value: value) }
    static func box(_ value: Int32)  -> NSObject { return NSNumber(value: value) }
    static func box(_ value: Int64)  -> NSObject { return NSNumber(value: value) }
    static func box(_ value: UInt)   -> NSObject { return NSNumber(value: value) }
    static func box(_ value: UInt8)  -> NSObject { return NSNumber(value: value) }
    static func box(_ value: UInt16) -> NSObject { return NSNumber(value: value) }
    static func box(_ value: UInt32) -> NSObject { return NSNumber(value: value) }
    static func box(_ value: UInt64) -> NSObject { return NSNumber(value: value) }
    static func box(_ value: String) -> NSObject { return NSString(string: value) }
    
    static func box(_ float: Float) throws -> NSObject {
        if float.isInfinite || float.isNaN { throw JSONObjectEncodingError.unsupportedFloatValue }
        return NSNumber(value: float)
    }
    
    static func box(_ double: Double) throws -> NSObject {
        if double.isInfinite || double.isNaN { throw JSONObjectEncodingError.unsupportedFloatValue }
        return NSNumber(value: double)
    }
    
    static func box(_ date: Date) throws -> NSObject {
        return DateEncoder.encode(date: date)
    }
    
    static func box(_ data: Data) throws -> NSObject {
        throw JSONObjectEncodingError.unsupportedDataValue
    }
    
    static func box<T : Encodable>(_ value: T) throws -> NSObject {
        
        // for types that we have a boxing strategy, use ours and not the one provided by their (synthesized) Encodable conformance
        if let date = value as? Date {
            return try self.box(date)
        } else if let data = value as? Data {
            return try self.box(data)
        } else if let url = value as? URL {
            return url.absoluteString as NSString
        } else if let decimal = value as? Decimal {
            return decimal as NSDecimalNumber // JSONSerialization can natively handle NSDecimalNumber
        }
        
        let nestedEncoder = JSONObjectEncoder()
        try value.encode(to: nestedEncoder)
        
        return nestedEncoder.json ?? NSDictionary()
    }
}

class DateEncoder {
    
    static let formatter: DateFormatter = {
        
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat  = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" // JavaScript format
        return formatter
    }()
    
    static func encode(date: Date) -> NSString {
        return formatter.string(from: date) as NSString
    }
}

protocol CodingPathIgnoring { }

extension CodingPathIgnoring {
    public var codingPath: [CodingKey] { return [] }
}

// Usage

struct Person: Codable {
    let name: String
    let age: Int
    let height: Double
    let isFemale: Bool
    let firstWorkDay: Date?
}

struct Family: Codable {
    let father: Person
    let mother: Person
    let children: [Person]
}

let hans = Person(name: "Hans", age: 65, height: 1.82, isFemale: false, firstWorkDay: Date(timeIntervalSince1970: 0))
let renate = Person(name: "Renate", age: 59, height: 1.66, isFemale: true, firstWorkDay: Date(timeIntervalSince1970: 300000000))
let karl = Person(name: "Karl", age: 27, height: 1.80, isFemale: false, firstWorkDay: Date())
let jana = Person(name: "Jana", age: 19, height: 1.73, isFemale: true, firstWorkDay: nil)

let theSchmidts = Family(father: hans, mother: renate, children: [karl, jana])

let encoder = JSONObjectEncoder()
try theSchmidts.encode(to: encoder)

if let json = encoder.json {
    
    let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
    String(data: jsonData, encoding: .utf8)
}
