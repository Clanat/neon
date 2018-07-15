//
//  WoWObject.swift
//  Neon
//
//  Created by Nikita Zatsepilov on 14/07/2018.
//

import Foundation

enum WoWObjectType: UInt8 {
    case none = 0
    case item = 1
    case container = 2
    case unit = 3
    case player = 4
    case gameObject = 5
    case dynamicObject = 6
    case corpse = 7
}

class WoWObject {
    
    private let memoryService = ServiceLocator.memoryService

    private(set) var address: UInt32
    let guid: UInt64
    let type: WoWObjectType
    
    var position: Vector3 {
        return (try? memoryService.read(Vector3.self, at: address + WoWObjectOffsets.position)) ?? .zero
    }
    
    var rotation: Float32 {
        return (try? memoryService.read(Float32.self, at: address + WoWObjectOffsets.rotation)) ?? 0
    }
    
    private var isValid: Bool {
        return address != 0
    }
    
    init(address: UInt32, guid: UInt64, type: WoWObjectType) {
        self.address = address
        self.guid = guid
        self.type = type
    }
    
    func invalidate() {
        address = 0
    }
}
