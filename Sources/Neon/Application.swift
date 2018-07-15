//
//  AppContext.swift
//  Neon
//
//  Created by Nikita Zatsepilov on 10/07/2018.
//

import Foundation
import Commander

extension DispatchQueue {
    static let application = DispatchQueue(label: "com.neon.app")
}

final class Application {
    static let current = Application()
    
    private let console = Console(playerService: ServiceLocator.playerService,
                                  objectService: ServiceLocator.objectService)
    
    static func run() {
        DispatchQueue.application.async {
            Application.current.setup()
            Application.current.run()
        }
        
        RunLoop.current.run()
    }
    
    private func setup() {
        ServiceLocator.apiService.connect()
        ServiceLocator.apiService
    }
    
    private func run() {
        console.run()
    }
}
