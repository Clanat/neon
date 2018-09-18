//
// Created by Nikita Zatsepilov on 14/07/2018.
//

import Foundation

protocol ObjectServiceProtocol {
    var currentPlayer: WoWPlayer { get }
    
    func update()
}

final class ObjectService: ObjectServiceProtocol {
    
    private let memoryService: MemoryServiceProtocol
    private let functionService: FunctionServiceProtocol
    private let playerService: PlayerServiceProtocol
    
    private var cachedObjects: [UInt64: WoWObject] = [:]
    
    var currentPlayer: WoWPlayer {
        let guid = playerService.playerGuid
        
        if cachedObjects[guid] == nil {
            update()
        }
        
        guard let object = cachedObjects[guid] else {
            fatalError("Player not found")
        }
        
        return WoWPlayer(address: object.address, guid: object.guid)
    }
    
    init(memoryService: MemoryServiceProtocol, functionService: FunctionServiceProtocol, playerService: PlayerServiceProtocol) {
        self.memoryService = memoryService
        self.functionService = functionService
        self.playerService = playerService
    }
    
    func update() {
        guard let result = try? functionService.getObjects() else {
            cachedObjects.forEach { record in
                record.value.invalidate()
            }
            cachedObjects = [:]
            return
        }
        
        let incomingGuids = result.guids
        for index in 0..<result.guids.count {
            let guid = result.guids[index]
            
            if cachedObjects[guid] == nil {
                let address = result.pointers[index]
                let type = objectType(from: result.types[index])
                cachedObjects[guid] = WoWObject(address: address, guid: guid, type: type)
            }
        }
        
        cachedObjects = cachedObjects.filter { (record: (guid: UInt64, object: WoWObject)) in
            if !incomingGuids.contains(record.guid) {
                record.object.invalidate()
                return false
            }
            return true
        }
    }
    
    private func objectType(from type: WoWObjectsResult.TypeEnum) -> WoWObjectType {
        switch type {
            case .none:
                return .none
            case .item:
                return .item
            case .container:
                return .container
            case .unit:
                return .unit
            case .player:
                return .player
            case .gameObject:
                return .gameObject
            case .dynamicObject:
                return .dynamicObject
            case .corpse:
                return .corpse
            case .UNRECOGNIZED:
                return .none
        }
    }
}
