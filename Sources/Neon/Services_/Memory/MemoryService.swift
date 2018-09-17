//
//  Created by Nikita Zatsepilov on 08/07/2018.
//

import Foundation
import SwiftProtobuf

// TODO: writing, MemoryBatchQuery

protocol MemoryServiceProtocol {
    func readBytes(at address: UInt32, count: Int32) throws -> Data
    func read(_ type: Int8.Type, at address: UInt32) throws -> Int8
    func read(_ type: UInt8.Type, at address: UInt32) throws -> UInt8
    func read(_ type: Int16.Type, at address: UInt32) throws -> Int16
    func read(_ type: UInt16.Type, at address: UInt32) throws -> UInt16
    func read(_ type: Int32.Type, at address: UInt32) throws -> Int32
    func read(_ type: UInt32.Type, at address: UInt32) throws -> UInt32
    func read(_ type: Int64.Type, at address: UInt32) throws -> Int64
    func read(_ type: UInt64.Type, at address: UInt32) throws -> UInt64
    func read(_ type: Float32.Type, at address: UInt32) throws -> Float32
    func read(_ type: Float64.Type, at address: UInt32) throws -> Float64
    func read(_ type: Bool.Type, at address: UInt32) throws -> Bool
    func read(_ type: Vector3.Type, at address: UInt32) throws -> Vector3
}

final class MemoryService: MemoryServiceProtocol {
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func readBytes(at address: UInt32, count: Int32) throws -> Data {
        var query = MemoryQuery()
        query.address = address
        query.size = count
    
        var request = Request()
        request.kind = .memoryQuery
        request.data = try query.serializedData()
        
        return try apiService.send(request).deserialize(MemoryQuery.Result.self).data
    }

    func read(_ type: Int8.Type, at address: UInt32) throws -> Int8 {
        return try readUnsafe(Int8.self, at: address)
    }
    
    func read(_ type: UInt8.Type, at address: UInt32) throws -> UInt8 {
        return try readUnsafe(UInt8.self, at: address)
    }
    
    func read(_ type: Int16.Type, at address: UInt32) throws -> Int16 {
        return try readUnsafe(Int16.self, at: address)
    }
    
    func read(_ type: UInt16.Type, at address: UInt32) throws -> UInt16 {
        return try readUnsafe(UInt16.self, at: address)
    }
    
    func read(_ type: Int32.Type, at address: UInt32) throws -> Int32 {
        return try readUnsafe(Int32.self, at: address)
    }
    
    func read(_ type: UInt32.Type, at address: UInt32) throws -> UInt32 {
        return try readUnsafe(UInt32.self, at: address)
    }
    
    func read(_ type: Int64.Type, at address: UInt32) throws -> Int64 {
        return try readUnsafe(Int64.self, at: address)
    }
    
    func read(_ type: UInt64.Type, at address: UInt32) throws -> UInt64 {
        return try readUnsafe(UInt64.self, at: address)
    }
    
    func read(_ type: Float32.Type, at address: UInt32) throws -> Float32 {
        return try readUnsafe(Float32.self, at: address)
    }
    
    func read(_ type: Float64.Type, at address: UInt32) throws -> Float64 {
        return try readUnsafe(Float64.self, at: address)
    }
    
    func read(_ type: Bool.Type, at address: UInt32) throws -> Bool {
        return try readUnsafe(UInt8.self, at: address) == 1
    }
    
    func read(_ type: Vector3.Type, at address: UInt32) throws -> Vector3 {
        return try readUnsafe(Vector3.self, at: address)
    }
    
    // MARK: - Private
    
    private func readUnsafe<Value>(_ type: Value.Type, at address: UInt32) throws -> Value {
        let valueSize = MemoryLayout<Value>.size
        let data = try readBytes(at: address, count: .init(valueSize))
        return data.withUnsafeBytes { pointer in
            return pointer.pointee
        }
    }
    
    private func readUnsafe<Value>(_ type: Value.Type, count: Int, at address: UInt32) throws -> [Value] {
        let size = MemoryLayout<Value>.size * count
        let data = try readBytes(at: address, count: .init(size))
        return data.withUnsafeBytes { (start: UnsafePointer<Value>) in
            let bufferPtr = UnsafeBufferPointer<Value>.init(start: start, count: count)
            return [Value](bufferPtr)
        }
    }
}
