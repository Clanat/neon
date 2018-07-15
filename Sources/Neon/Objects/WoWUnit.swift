//
//  WoWUnit.swift
//  Neon
//
//  Created by Nikita Zatsepilov on 14/07/2018.
//

import Foundation

class WoWUnit: WoWObject {
    convenience init(address: UInt32, guid: UInt64) {
        self.init(address: address, guid: guid, type: .unit)
    }
}
