//
//  PlayerController.swift
//  Neon
//
//  Created by Nikita Zatsepilov on 13/07/2018.
//

import Foundation

protocol PlayerServiceProtocol {
    var isPlayerOnline: Bool { get }
    var playerGuid: UInt64 { get }
    var playerPointer: UInt32 { get }
    var mapId: UInt32 { get }
}

final class PlayerService: PlayerServiceProtocol {
    
    private let memoryService: MemoryServiceProtocol
    private let functionService: FunctionServiceProtocol
    
    var isPlayerOnline: Bool {
        return (try? memoryService.read(Bool.self, at: Offsets.isPlayerOnline)) ?? false
    }
    
    var playerGuid: UInt64 {
        return (try? functionService.getActivePlayerGuid()) ?? 0
    }
    
    var playerPointer: UInt32 {
        return (try? functionService.getActivePlayerPointer()) ?? 0
    }
    
    var mapId: UInt32 {
        return (try? functionService.getMapId()) ?? 0
    }
    
    init(memoryService: MemoryServiceProtocol, functionService: FunctionServiceProtocol) {
        self.memoryService = memoryService
        self.functionService = functionService
    }
}
