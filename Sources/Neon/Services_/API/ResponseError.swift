//
//  ResponseError.swift
//  Neon
//
//  Created by Nikita Zatsepilov on 14/07/2018.
//

import Foundation

enum ResponseError {
    case with(String)
}

extension ResponseError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case let .with(message):
                return message
        }
    }
}
