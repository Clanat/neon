//
// Created by Nikita Zatsepilov on 15/07/2018.
//

import Foundation

protocol MovementServiceProtocol {
    func start()
    func stopMovement()
    func move(with points: [Vector3])
}

final class MovementService: MovementServiceProtocol {
    
    private let objectService: ObjectServiceProtocol
    private let functionService: FunctionServiceProtocol
    
    private let pointsQueue = Queue<Vector3>()
    
    private lazy var updateTimer: DispatchSourceTimer = {
        let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.application)
        timer.schedule(deadline: .now(), repeating: .seconds(1), leeway: .milliseconds(100))
        timer.setEventHandler { [weak self] in
            self?.performUpdate()
        }
        return timer
    }()
    
    init(objectService: ObjectServiceProtocol, functionService: FunctionServiceProtocol) {
        self.objectService = objectService
        self.functionService = functionService
    }
    
    deinit {
        updateTimer.cancel()
    }
    
    func start() {
        updateTimer.resume()
    }
    
    func move(with points: [Vector3]) {
        pointsQueue.enqueue(points)
    }
    
    // MARK: - Private
    
    func stopMovement() {
        perform(action: .idle, point: objectService.currentPlayer.position)
    }
    
    @discardableResult
    private func perform(action: ClickAction, to target: WoWObject? = nil, point: Vector3) -> Bool {
        return perform(action: action, targetGuid: target?.guid ?? 0, point: point)
    }
    
    @discardableResult
    private func perform(action: ClickAction, targetGuid: UInt64, point: Vector3) -> Bool {
        let result = try? functionService.clickToMove(action: action,
                                                      point: point,
                                                      targetGuid: targetGuid,
                                                      precision: 0)
        return result ?? false
    }
    
    private func performUpdate() {
        guard let destination = pointsQueue.front else {
            return
        }
    
        let position = objectService.currentPlayer.position
        guard position.distance(to: destination) < 0.3 else {
            perform(action: .move, point: destination)
            return
        }
        
        pointsQueue.dequeue()
        if !pointsQueue.isEmpty {
            performUpdate()
        }
    }
}
