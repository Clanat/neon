//
// Created by Nikita Zatsepilov on 15/07/2018.
//

import Foundation

enum ClickAction: UInt32 {
    case faceTarget = 0x1
    case face = 0x2
    case stopUnsafe = 0x3
    case move = 0x4
    case interactWithNpc = 0x5
    case interactWithObject = 0x7
    case faceUnused = 0x8
    case skin = 0x9
    case attackAtPosition = 0xA
    case attackByGuid = 0xB
    case constantFace = 0xC
    case none = 0xD
    case attack = 0x10
    case idle = 0x13
}
