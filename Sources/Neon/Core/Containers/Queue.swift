//
// Created by Nikita Zatsepilov on 15/07/2018.
//

import Foundation

class Queue<Element> {
    private var elements: [Element] = []
    
    var count: Int {
        return elements.count
    }
    
    var isEmpty: Bool {
        return elements.isEmpty
    }
    
    var front: Element? {
        return elements.first
    }
    
    func enqueue(_ element: Element) {
        elements.append(element)
    }
    
    func enqueue(_ elements: [Element]) {
        self.elements += elements
    }
    
    @discardableResult
    func dequeue() -> Element? {
        guard !elements.isEmpty else {
            return nil
        }
        
        return elements.removeFirst()
    }
    
    func removeAll() {
        elements.removeAll()
    }
}
