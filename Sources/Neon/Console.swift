//
//  Console.swift
//  Commander
//
//  Created by Nikita Zatsepilov on 13/07/2018.
//

import Dispatch
import Commander
import LineNoise

final class Console {
    private let queue: DispatchQueue
    private var isRunning: Bool = false
    
    private let lineNoise: LineNoise
    private var consoleGroup: Group!
    
    private let playerService: PlayerServiceProtocol
    private let objectService: ObjectServiceProtocol
    
    init(playerService: PlayerServiceProtocol, objectService: ObjectServiceProtocol) {
        self.playerService = playerService
        self.objectService = objectService
        
        queue = .init(label: "com.neon.console")
        lineNoise = LineNoise()
        lineNoise.setHistoryMaxLength(200)
        consoleGroup = createConsoleGroup()
    }
    
    func run() {
        // #swiftlint:disable all
        let logo = """
      ___           ___           ___           ___
     /__/\\         /  /\\         /  /\\         /__/\\
     \\  \\:\\       /  /:/_       /  /::\\        \\  \\:\\
      \\  \\:\\     /  /:/ /\\     /  /:/\\:\\        \\  \\:\\
  _____\\__\\:\\   /  /:/ /:/_   /  /:/  \\:\\   _____\\__\\:\\
 /__/::::::::\\ /__/:/ /:/ /\\ /__/:/ \\__\\:\\ /__/::::::::\\
 \\  \\:\\~~\\~~\\/ \\  \\:\\/:/ /:/ \\  \\:\\ /  /:/ \\  \\:\\~~\\~~\\/
  \\  \\:\\  ~~~   \\  \\::/ /:/   \\  \\:\\  /:/   \\  \\:\\  ~~~
   \\  \\:\\        \\  \\:\\/:/     \\  \\:\\/:/     \\  \\:\\
    \\  \\:\\        \\  \\::/       \\  \\ ::/       \\  \\:\\
     \\__\\/         \\__\\/         \\__\\/         \\__\\/
"""
        print(logo)
        // #swiftlint:enable all
        
        isRunning = true
        queue.async {
            while self.isRunning {
                self.processInput()
            }
        }
    }
    
    private func processInput() {
        print("$ ", terminator: "")
        guard let text = readLine() else {
            return
        }

        do {
            let args = text.components(separatedBy: " ")
            try consoleGroup.run(args)
        }
        catch {
            print(error)
        }
        print("")
    }
}

extension Console {
    private func createConsoleGroup() -> Group {
        return Group { consoleGroup in
            consoleGroup.group("player", closure: createPlayerCommands)
            consoleGroup.group("objects", closure: createObjectCommands)
            consoleGroup.command("help") {
                print("TODO")
            }
        }
    }
}

// MARK: - Player

extension Console {
    private func createPlayerCommands(in group: Group) {
        group.command("info") {
            let player = self.objectService.currentPlayer
            print("MapID: \(self.playerService.mapId)")
            print("GUID: \(self.playerService.playerGuid)")
            print("POSITION: \(player.position)")
            print(String(format: "POINTER: %p", self.playerService.playerPointer))
        }
        
        group.command("pointer") {
            print("POINTER: \(self.playerService.playerPointer)")
        }
        
        group.command("move") { (pointX: Float32, pointY: Float32, pointZ: Float32) in
            let player = self.objectService.currentPlayer
            var point = player.position
            point.y -= 0.001
            
            try! ServiceLocator.functionService.clickToMove(action: .move,
                                                            point: point,
                                                            targetGuid: player.guid,
                                                            precision: 0)
        }
        
        group.command("movetest") {
//            let points = [
//                Vector3(x: 32.8169, y: 2458.51, z: -4.29713),
//                Vector3(x: 33.672, y: 2469.14, z: -4.29713),
//                Vector3(x: 28.2157, y: 2472.06, z: -4.29713),
//                Vector3(x: 27.1028, y: 2484.7, z: -4.29555),
//                Vector3(x: 21.4715, y: 2490.49, z: -4.29466),
//                Vector3(x: 17.6167, y: 2499.29, z: -4.29588),
//                Vector3(x: 18.3302, y: 2508.11, z: -4.29358)
//            ]
//
//            MovementManager.current.moveByPath(points)
        }
        
        group.command("movecancel") {
//            MovementManager.current.cancelMove()
        }
    }
}

// MARK: Objects

extension Console {
    private func createObjectCommands(in group: Group) {
        group.command("dump") {
            
        }
    }
}
