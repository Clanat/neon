//
//  Geometry.swift
//  Vector3
//
//  Created by Nikita Zatsepilov on 14/07/2018.
//

// #swiftlint:disable identifier_name shorthand_operator

import Foundation

struct Vector3 {
    var x: Float32 = 0
    var y: Float32 = 0
    var z: Float32 = 0
    
    static var zero: Vector3 {
        return Vector3()
    }
    
    var magnitude: Float32 {
        return sqrtf(x*x + y*y + z*z)
    }
    
    init() {
        x = 0
        y = 0
        z = 0
    }
    
    init(value: Float32) {
        x = value
        y = value
        z = value
    }
    
    init(x: Float32, y: Float32, z: Float32) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    init(other: Vector3) {
        x = other.x
        y = other.y
        z = other.z
    }
    
    func distance(to other: Vector3) -> Float32 {
        let result = self - other
        return sqrt( result.dot(result) )
    }
    
    mutating func normalize() {
        let m = magnitude
        if m > 0 {
            let il = 1.0 / m
            x *= il
            y *= il
            z *= il
        }
    }
    
    mutating func setMagnitude(lenght: Float32) {
        let m = magnitude
        if m > 0 {
            let newLength = lenght / m
            x *= newLength
            y *= newLength
            z *= newLength
        }
    }
    
    func distanceSquared(to vector: Vector3) -> Float32 {
        let result = self - vector
        return result.dot(result)
    }
    
    func dot(_ v: Vector3) -> Float32 {
        return x * v.x + y * v.y + z * v.z
    }
    
    mutating func lerp(a: Vector3, b: Vector3, coef: Float32) {
        let result = a + ( b - a) * coef

        x = result.x
        y = result.y
        z = result.z
    }
    
    mutating func cross(with left: Vector3, to right: Vector3) {
        let a = (left.y * right.z) - (left.z * right.y)
        let b = (left.z * right.x) - (left.x * right.z)
        let c = (left.x * right.y) - (left.y * right.x)
        
        x = a
        y = b
        z = c
    }
    
    func cross(with other: Vector3) -> Vector3 {
        var temp = Vector3()
        temp.cross(with: self, to: other)
        return temp
    }
    
    mutating func set(with other: Vector3) {
        x = other.x
        y = other.y
        z = other.z
    }
    
    mutating func setNegative(with other: Vector3) {
        x = -other.x
        y = -other.y
        z = -other.z
    }
    
    mutating func negate() {
        x = -x
        y = -y
        z = -z
    }
    
    mutating func min(other: Vector3) {
        x = Swift.min(x, other.x)
        y = Swift.min(y, other.y)
        z = Swift.min(z, other.z)
    }
    
    mutating func max(other: Vector3) {
        x = Swift.max(x, other.x)
        y = Swift.max(y, other.y)
        z = Swift.max(z, other.z)
    }
}

extension Vector3: CustomStringConvertible {
    var description: String { return "[\(x),\(y),\(z)]" }
}

extension Vector3: Equatable {
    static func == (lhs: Vector3, rhs: Vector3) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }
}

extension Vector3 {
    static func * (left: Vector3, right: Float32) -> Vector3 {
        return Vector3(x: left.x * right, y: left.y * right, z: left.z * right)
    }
    
    static func * (left: Vector3, right: Vector3) -> Vector3 {
        return Vector3(x: left.x * right.x, y: left.y * right.y, z: left.z * right.z)
    }
    
    static func / (left: Vector3, right: Float32) -> Vector3 {
        return Vector3(x: left.x / right, y: left.y / right, z: left.z / right)
    }
    
    static func / (left: Vector3, right: Vector3) -> Vector3 {
        return Vector3(x: left.x / right.x, y: left.y / right.y, z: left.z / right.z)
    }
    
    static func + (left: Vector3, right: Vector3) -> Vector3 {
        return Vector3(x: left.x + right.x, y: left.y + right.y, z: left.z + right.z)
    }
    
    static func - (left: Vector3, right: Vector3) -> Vector3 {
        return Vector3(x: left.x - right.x, y: left.y - right.y, z: left.z - right.z)
    }
    
    static func + (left: Vector3, right: Float32) -> Vector3 {
        return Vector3(x: left.x + right, y: left.y + right, z: left.z + right)
    }
    
    static func - (left: Vector3, right: Float32) -> Vector3 {
        return Vector3(x: left.x - right, y: left.y - right, z: left.z - right)
    }
    
    static func += (left: inout Vector3, right: Vector3) {
        left = left + right
    }
    
    static func -= (left: inout Vector3, right: Vector3) {
        left = left - right
    }
    
    static func *= (left: inout Vector3, right: Vector3) {
        left = left * right
    }
    
    static func /= (left: inout Vector3, right: Vector3) {
        left = left / right
    }
}

// #swiftlint:enable identifier_name shorthand_operator

