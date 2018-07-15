//
//  FunctionService.swift
//  Neon
//
//  Created by Nikita Zatsepilov on 14/07/2018.
//

import Foundation

protocol FunctionServiceProtocol {
    func getObjectPointer(byGuid guid: UInt64) throws -> UInt32
    func getActivePlayerGuid() throws -> UInt64
    func getActivePlayerPointer() throws -> UInt32
    func getMapId() throws -> UInt32
    func getObjects() throws -> WoWObjectsResult
    func clickToMove(action: ClickAction, point: Vector3, targetGuid: UInt64, precision: Float32) throws -> Bool
}

final class FunctionService: FunctionServiceProtocol {
    
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func getObjectPointer(byGuid guid: UInt64) throws -> UInt32 {
        var query = FunctionQuery()
        query.kind = .objectPointer
        var guid = guid
        query.args = [Data(bytes: &guid, count: MemoryLayout.size(ofValue: guid))]
        return try execute(query)
    }
    
    func getActivePlayerGuid() throws -> UInt64 {
        var query = FunctionQuery()
        query.kind = .activePlayerGuid
        return try execute(query)
    }
    
    func getActivePlayerPointer() throws -> UInt32 {
        var query = FunctionQuery()
        query.kind = .activePlayerPointer
        return try execute(query)
    }
    
    func getMapId() throws -> UInt32 {
        var query = FunctionQuery()
        query.kind = .mapID
        return try execute(query)
    }
    
    func getObjects() throws -> WoWObjectsResult {
        var query = FunctionQuery()
        query.kind = .enumVisibleObjects
        let result = try WoWObjectsResult(serializedData: try execute(query))
        return result
    }
    
    func clickToMove(action: ClickAction, point: Vector3, targetGuid: UInt64, precision: Float32) throws -> Bool {
        var query = FunctionQuery()
        query.kind = .clickToMove
        
        var action = action.rawValue
        var point = point
        var targetGuid = targetGuid
        var precision = precision
        query.args = [
            Data(bytes: &action, count: MemoryLayout.size(ofValue: action)),
            Data(bytes: &point, count: MemoryLayout.size(ofValue: point)),
            Data(bytes: &targetGuid, count: MemoryLayout.size(ofValue: targetGuid)),
            Data(bytes: &precision, count: MemoryLayout.size(ofValue: precision))
        ]
        
        return try execute(query)
    }
    
    // MARK: - Private
    
    private func execute<Result>(_ query: FunctionQuery) throws -> Result {
        return try execute(query).withUnsafeBytes { pointer in
            return pointer.pointee
        }
    }
    
    @discardableResult
    private func execute(_ query: FunctionQuery) throws -> Data {
        var request = Request()
        request.data = try query.serializedData()
        request.kind = .functionQuery
        return try apiService.send(request).deserialize(FunctionQuery.Result.self).data
    }
}
