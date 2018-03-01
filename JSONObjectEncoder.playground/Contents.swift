// This is lightweight version of https://github.com/apple/swift/blob/master/stdlib/public/SDK/Foundation/JSONEncoder.swift

import Foundation

enum JSONObjectEncoderError: Error {
    case unsupportedValue(value: Any)
}

class JSONObjectEncoder : Encoder {
    
    private(set) var json : NSObject?
    
    public let codingPath: [CodingKey] = []
    public let userInfo: [CodingUserInfoKey : Any] = [:]
    
    public func container<Key>(keyedBy: Key.Type) -> KeyedEncodingContainer<Key> {
        let container = JSONObjectEncoderKeyedContainer<Key>()
        json = container.dictionary
        return KeyedEncodingContainer(container)
    }
    
    public func unkeyedContainer() -> UnkeyedEncodingContainer {
        let container = JSONObjectEncoderUnkeyedContainer()
        json = container.array
        return container
    }
    
    public func singleValueContainer() -> SingleValueEncodingContainer {
        return self
    }
}

fileprivate struct JSONObjectEncoderKeyedContainer<K : CodingKey> : KeyedEncodingContainerProtocol {
    typealias Key = K
    
    public let dictionary = NSMutableDictionary()
    public let codingPath: [CodingKey] = []
    
    public mutating func encodeNil(forKey key: Key) throws { dictionary[key.stringValue] = NSNull() }
    public mutating func encode(_ value: Bool, forKey key: Key) throws { dictionary[key.stringValue] = JSONObjectBoxer.box(value) }
    public mutating func encode(_ value: Int, forKey key: Key) throws { dictionary[key.stringValue] = JSONObjectBoxer.box(value) }
    public mutating func encode(_ value: Int8, forKey key: Key) throws { dictionary[key.stringValue] = JSONObjectBoxer.box(value) }
    public mutating func encode(_ value: Int16, forKey key: Key) throws { dictionary[key.stringValue] = JSONObjectBoxer.box(value) }
    public mutating func encode(_ value: Int32, forKey key: Key) throws { dictionary[key.stringValue] = JSONObjectBoxer.box(value) }
    public mutating func encode(_ value: Int64, forKey key: Key) throws { dictionary[key.stringValue] = JSONObjectBoxer.box(value) }
    public mutating func encode(_ value: UInt, forKey key: Key) throws { dictionary[key.stringValue] = JSONObjectBoxer.box(value) }
    public mutating func encode(_ value: UInt8, forKey key: Key) throws { dictionary[key.stringValue] = JSONObjectBoxer.box(value) }
    public mutating func encode(_ value: UInt16, forKey key: Key) throws { dictionary[key.stringValue] = JSONObjectBoxer.box(value) }
    public mutating func encode(_ value: UInt32, forKey key: Key) throws { dictionary[key.stringValue] = JSONObjectBoxer.box(value) }
    public mutating func encode(_ value: UInt64, forKey key: Key) throws { dictionary[key.stringValue] = JSONObjectBoxer.box(value) }
    public mutating func encode(_ value: String, forKey key: Key) throws { dictionary[key.stringValue] = JSONObjectBoxer.box(value) }
    public mutating func encode(_ value: Float, forKey key: Key) throws { dictionary[key.stringValue] = try JSONObjectBoxer.box(value) }
    public mutating func encode(_ value: Double, forKey key: Key) throws { dictionary[key.stringValue] = try JSONObjectBoxer.box(value) }
    public mutating func encode<T : Encodable>(_ value: T, forKey key: Key) throws { dictionary[key.stringValue] = try JSONObjectBoxer.box(value) }
    
    public mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> {
        let container = JSONObjectEncoderKeyedContainer<NestedKey>()
        dictionary[key.stringValue] = container.dictionary
        return KeyedEncodingContainer(container)
    }
    
    public mutating func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        let container = JSONObjectEncoderUnkeyedContainer()
        dictionary[key.stringValue] = container.array
        return container
    }
    
    public mutating func superEncoder() -> Encoder {
        fatalError()
    }
    
    public mutating func superEncoder(forKey key: Key) -> Encoder {
        fatalError()
    }
}

fileprivate struct JSONObjectEncoderUnkeyedContainer : UnkeyedEncodingContainer {
    
    public let array = NSMutableArray()
    public let codingPath: [CodingKey] = []
    public var count: Int { return self.array.count }
    
    public mutating func encodeNil()             throws { array.add(NSNull()) }
    public mutating func encode(_ value: Bool)   throws { array.add(JSONObjectBoxer.box(value)) }
    public mutating func encode(_ value: Int)    throws { array.add(JSONObjectBoxer.box(value)) }
    public mutating func encode(_ value: Int8)   throws { array.add(JSONObjectBoxer.box(value)) }
    public mutating func encode(_ value: Int16)  throws { array.add(JSONObjectBoxer.box(value)) }
    public mutating func encode(_ value: Int32)  throws { array.add(JSONObjectBoxer.box(value)) }
    public mutating func encode(_ value: Int64)  throws { array.add(JSONObjectBoxer.box(value)) }
    public mutating func encode(_ value: UInt)   throws { array.add(JSONObjectBoxer.box(value)) }
    public mutating func encode(_ value: UInt8)  throws { array.add(JSONObjectBoxer.box(value)) }
    public mutating func encode(_ value: UInt16) throws { array.add(JSONObjectBoxer.box(value)) }
    public mutating func encode(_ value: UInt32) throws { array.add(JSONObjectBoxer.box(value)) }
    public mutating func encode(_ value: UInt64) throws { array.add(JSONObjectBoxer.box(value)) }
    public mutating func encode(_ value: String) throws { array.add(JSONObjectBoxer.box(value)) }
    public mutating func encode(_ value: Float)  throws { array.add(try JSONObjectBoxer.box(value)) }
    public mutating func encode(_ value: Double) throws { array.add(try JSONObjectBoxer.box(value)) }
    public mutating func encode<T : Encodable>(_ value: T) throws { array.add(try JSONObjectBoxer.box(value)) }
    
    public mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> {
        let container = JSONObjectEncoderKeyedContainer<NestedKey>()
        array.add(container.dictionary)
        return KeyedEncodingContainer(container)
    }
    
    public mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        let container = JSONObjectEncoderUnkeyedContainer()
        array.add(container.array)
        return container
    }
    
    public mutating func superEncoder() -> Encoder {
        fatalError()
    }
}

extension JSONObjectEncoder : SingleValueEncodingContainer {

    public func encodeNil() throws { json = NSNull() }
    public func encode(_ value: Bool) throws { json = JSONObjectBoxer.box(value) }
    public func encode(_ value: Int) throws { json = JSONObjectBoxer.box(value) }
    public func encode(_ value: Int8) throws { json = JSONObjectBoxer.box(value) }
    public func encode(_ value: Int16) throws { json = JSONObjectBoxer.box(value) }
    public func encode(_ value: Int32) throws { json = JSONObjectBoxer.box(value) }
    public func encode(_ value: Int64) throws { json = JSONObjectBoxer.box(value) }
    public func encode(_ value: UInt) throws { json = JSONObjectBoxer.box(value) }
    public func encode(_ value: UInt8) throws { json = JSONObjectBoxer.box(value) }
    public func encode(_ value: UInt16) throws { json = JSONObjectBoxer.box(value) }
    public func encode(_ value: UInt32) throws { json = JSONObjectBoxer.box(value) }
    public func encode(_ value: UInt64) throws { json = JSONObjectBoxer.box(value) }
    public func encode(_ value: String) throws { json = JSONObjectBoxer.box(value) }
    public func encode(_ value: Float) throws { json = try JSONObjectBoxer.box(value) }
    public func encode(_ value: Double) throws { json = try JSONObjectBoxer.box(value) }
    public func encode<T : Encodable>(_ value: T) throws { json = try JSONObjectBoxer.box(value) }
}

class JSONObjectBoxer {
    
    // This could be replaces by a custom closure if necessary
    public static var formatDate: (Date) -> (NSString) = {
        if #available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *) {
            
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = .withInternetDateTime
            
            return { NSString(string: formatter.string(from: $0)) }
            
        } else {
            
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat  = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            
            return { NSString(string: formatter.string(from: $0)) }
        }
    }()
    
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
        if float.isInfinite || float.isNaN { throw JSONObjectEncoderError.unsupportedValue(value: float) }
        return NSNumber(value: float)
    }
    
    static func box(_ double: Double) throws -> NSObject {
        if double.isInfinite || double.isNaN { throw JSONObjectEncoderError.unsupportedValue(value: double) }
        return NSNumber(value: double)
    }
    
    static func box(_ date: Date) throws -> NSObject {
        return JSONObjectBoxer.formatDate(date)
    }
    
    static func box(_ data: Data) throws -> NSObject {
        throw JSONObjectEncoderError.unsupportedValue(value: data)
    }
    
    static func box<T : Encodable>(_ value: T) throws -> NSObject {
        
        // override synthesized Encodable implementation for certain types
        if let date = value as? Date {
            return JSONObjectBoxer.formatDate(date)
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
