//
//  Created by Nikita Zatsepilov on 08/07/2018.
//

import Foundation
import CZeroMQ
import SwiftProtobuf

protocol APIServiceProtocol {
    @discardableResult
    func connect() -> Bool
    
    func send(_ request: Request) throws -> Response
}

final class APIService: APIServiceProtocol {
    
    private let address: String
    private let context: UnsafeMutableRawPointer
    private let socket: UnsafeMutableRawPointer
    
    var connectHandler: (() -> Void)?
    var disconnectHandler: (() -> Void)?
    
    init(address: String) {
        self.address = address
        context = zmq_ctx_new()
        socket = zmq_socket(context, ZMQ_REQ)
    }
    
    @discardableResult
    func connect() -> Bool {
        return zmq_connect(socket, address) == 0
    }
    
    func send(_ request: Request) throws -> Response {
        var data = try request.serializedData()
        let dataPtr = data.withUnsafeMutableBytes { (ptr: UnsafeMutablePointer<UInt8>) in
            return ptr
        }
        
        guard zmq_send(socket, .init(dataPtr), data.count, 0) == data.count else {
            throw ZMQError.last
        }
        
        var incomingBytes = [UInt8](repeating: 0, count: 2048)
        let incomingBytesCount = zmq_recv(socket, &incomingBytes, 2048, 0)
        
        guard incomingBytesCount > 0 else {
            fatalError("Received invalid message from backend")
        }
        
        let serializedData = Data(bytes: incomingBytes[0..<Int(incomingBytesCount)])
        let response = try Response(serializedData: serializedData)
        
        switch response.kind {
        case .error:
            let error = try Response.Error(serializedData: response.data)
            throw ResponseError.with(error.message)
        default:
            return response
        }
    }
}
