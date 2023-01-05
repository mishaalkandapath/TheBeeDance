//
//  UtilsSupp.swift
//  
//
//  Created by Mishaal Kandapath on 5/9/20.
//

import PlaygroundSupport
import SpriteKit
import ARKit
import SceneKit


public extension SCNGeometry {
    class func lineFrom(vector vector1: SCNVector3, toVector vector2: SCNVector3) -> SCNGeometry {
        let indices: [Int32] = [0, 1]

        let source = SCNGeometrySource(vertices: [vector1, vector2])
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)

        return SCNGeometry(sources: [source], elements: [element])
    }
}

public extension SCNVector3 {
    static func distanceFrom(vector vector1: SCNVector3, toVector vector2: SCNVector3) -> Float {
        let x0 = vector1.x
        let x1 = vector2.x
        let y0 = vector1.y
        let y1 = vector2.y
        let z0 = vector1.z
        let z1 = vector2.z

        return sqrtf(powf(x1-x0, 2) + powf(y1-y0, 2) + powf(z1-z0, 2))
    }
}

public extension Float {
 
    // Returns a random floating point number between 0.0 and 1.0, inclusive.
 
    static var random:Float {
        get {
            return Float(arc4random()) / 0xFFFFFFFF
        }
    }
    /*
     Create a random num Float
     
     - parameter min: Float
     - parameter max: Float
     
     - returns: Float
     */
    static func random(min: Float, max: Float) -> Float {
        return Float.random * (max - min) + min
    }
}
public extension Float {
    func metersToInches() -> Float {
        return self * 39.3701
    }
}
