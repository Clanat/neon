//
//  ZMQError.swift
//  Neon
//
//  Created by Nikita Zatsepilov on 14/07/2018.
//

import Foundation
import CZeroMQ

final class ZMQError {
    let number: Int32
    let message: String
    
    private init() {
        number = zmq_errno()
        message = .init(cString: zmq_strerror(number))
    }
    
    static var last: ZMQError {
        return .init()
    }
}

extension ZMQError: CustomDebugStringConvertible {
    var debugDescription: String {
        return errorDescription ?? message
    }
}

extension ZMQError: LocalizedError {
    var errorDescription: String? {
        return message
    }
}
