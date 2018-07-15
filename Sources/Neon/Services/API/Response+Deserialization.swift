//
//  Response+Parsing.swift
//  Neon
//
//  Created by Nikita Zatsepilov on 14/07/2018.
//

import Foundation
import SwiftProtobuf

extension Response {
    func deserialize<Result: Message>(_ type: Result.Type) throws -> Result {
        return try Result(serializedData: data)
    }
}
