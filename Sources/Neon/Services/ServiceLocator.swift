//
// Created by Nikita Zatsepilov on 11/07/2018.
//

import Foundation

final class ServiceLocator {
    private static let current = ServiceLocator()
    
    private lazy var apiService: APIService = .init(address: "tcp://192.168.0.24:60000")
    private lazy var memoryService: MemoryService = .init(apiService: apiService)
    private lazy var functionService: FunctionService = .init(apiService: apiService)
    
    private lazy var playerService: PlayerService = .init(memoryService: memoryService,
                                                          functionService: functionService)
    
    private lazy var objectService: ObjectService = .init(memoryService: memoryService,
                                                          functionService: functionService,
                                                          playerService: playerService)
    
    private lazy var movementService: MovementService = .init(objectService: objectService,
                                                              functionService: functionService)
    
    private init() {
        
    }
}

extension ServiceLocator {
    static var apiService: APIServiceProtocol {
        return current.apiService
    }
    
    static var memoryService: MemoryServiceProtocol {
        return current.memoryService
    }
    
    static var functionService: FunctionServiceProtocol {
        return current.functionService
    }
    
    static var playerService: PlayerServiceProtocol {
        return current.playerService
    }
    
    static var objectService: ObjectServiceProtocol {
        return current.objectService
    }
    
    static var movementService: MovementServiceProtocol {
        return current.movementService
    }
}
