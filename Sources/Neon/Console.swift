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
    
    private var consoleGroup: Group!
    
    private let playerService: PlayerServiceProtocol
    private let objectService: ObjectServiceProtocol
    
    init(playerService: PlayerServiceProtocol, objectService: ObjectServiceProtocol) {
        self.playerService = playerService
        self.objectService = objectService
        
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
    }
}

// MARK: Objects

extension Console {
    private func createObjectCommands(in group: Group) {
    
    }
}
