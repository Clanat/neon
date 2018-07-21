//
//  Console.swift
//  Commander
//
//  Created by Nikita Zatsepilov on 13/07/2018.
//

import Dispatch
import Commander

final class Console {
    private let queue: DispatchQueue
    private var isRunning: Bool = false
    
    private var consoleGroup: Group!
    
    private let playerService: PlayerServiceProtocol
    private let objectService: ObjectServiceProtocol
    private let functionService: FunctionServiceProtocol
    private let movementService: MovementServiceProtocol
    
    init(playerService: PlayerServiceProtocol,
         objectService: ObjectServiceProtocol,
         functionService: FunctionServiceProtocol,
         movementService: MovementServiceProtocol) {
        self.playerService = playerService
        self.objectService = objectService
        self.functionService = functionService
        self.movementService = movementService
        
        queue = .init(label: "com.neon.console")
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
    \\  \\:\\        \\  \\::/       \\  \\::/       \\  \\:\\
     \\__\\/         \\__\\/         \\__\\/         \\__\\/
"""
        print(logo)
        // #swiftlint:enable all
        
        isRunning = true
        queue.async {
            while self.isRunning {
                print(" ⚡ ", terminator: "")
                self.processInput()
            }
        }
    }
    
    private func processInput() {
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
    }
    
    private func createConsoleGroup() -> Group {
        return Group { consoleGroup in
            consoleGroup.group("player", closure: createPlayerCommands)
            consoleGroup.group("dev", closure: createDevCommands)
            consoleGroup.command("help") {
                print("TODO")
            }
        }
    }
    
    // MARK: - Player
    
    private func createPlayerCommands(in group: Group) {
        group.command("info") {
            let player = self.objectService.currentPlayer
            print("MapID: \(self.playerService.mapId)")
            print("GUID: \(self.playerService.playerGuid)")
            print("POSITION: \(player.position)")
            print(String(format: "POINTER: %p", self.playerService.playerPointer))
        }
    }
    
    // MARK: - Dev
    
    private func createDevCommands(in group: Group) {
        group.command("point") {
            let position = self.objectService.currentPlayer.position
            print("Vector3(x: \(position.x), y: \(position.y), z: \(position.z))")
        }
        
        group.command("movepath") {
            let points = [
                Vector3(x: 1692.79, y: 1559.04, z: 123.178),
                Vector3(x: 1683.69, y: 1551.64, z: 124.757),
                Vector3(x: 1678.78, y: 1541.87, z: 125.163),
                Vector3(x: 1678.32, y: 1532.55, z: 125.054),
                Vector3(x: 1682.18, y: 1530.31, z: 124.81),
                Vector3(x: 1690.3, y: 1529.67, z: 124.758),
                Vector3(x: 1698.11, y: 1528.03, z: 125.876),
                Vector3(x: 1700.83, y: 1530.69, z: 126.076),
                Vector3(x: 1704.01, y: 1533.94, z: 127.51),
                Vector3(x: 1701.08, y: 1542.66, z: 124.253),
                Vector3(x: 1699.85, y: 1550.55, z: 123.488),
                Vector3(x: 1694.23, y: 1558.84, z: 123.374)
            ]
            
            self.movementService.move(with: points)
        }
        
        group.command("movestop") {
            self.movementService.stopMovement()
        }
    }
}
