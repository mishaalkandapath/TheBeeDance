//
//  Field.swift
//  
//
//  Created by Mishaal Kandapath on 5/9/20.
//

import Foundation
import PlaygroundSupport
import SpriteKit
import ARKit
import SceneKit

public protocol PointGenerator {
    mutating func generatePoints(numPoints: Int, maxWidth: Float, maxLength: Float) -> [CGPoint]
}



public class Visualizer: SCNNode {
    let controlNode = SCNNode()
    
    public init(with points: [CGPoint]) {
        super.init()
        controlNode.geometry?.firstMaterial?.diffuse.contents = UIColor.green
        self.addChildNode(controlNode)
        points.forEach { (point) in
            let sphere = self.createSphere(size: 0.03)
            let endScale: Float = 0.01
            sphere.scale = SCNVector3(endScale, 0.0, endScale)
            let duration = 1.0;
            let startScale = sphere.scale.y;

            let delay = SCNAction.wait(duration: TimeInterval(Float.random(min: 0.1, max: 0.5)))
            let scaleUp = SCNAction.customAction(duration: duration, action: { (node, elapsedTime) in
                let currentScale = CGFloat(startScale) + CGFloat(endScale) * (elapsedTime / CGFloat(duration))
                node.scale = SCNVector3Make(endScale, Float(currentScale), endScale)
            })
            let sequence = SCNAction.sequence([delay, scaleUp])
            sphere.runAction(sequence)
            sphere.position = SCNVector3(Float(point.x), -0.09, Float(point.y))
            controlNode.addChildNode(sphere)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSphere(size: Float) -> SCNNode {
        /*let sphere = SCNSphere(radius: CGFloat(size))
        sphere.firstMaterial?.diffuse.contents = UIColor.green
        
        let node = SCNNode(geometry: sphere)*/
        let scene = SCNScene(named:"flower.scn")!
        let node = scene.rootNode.childNode(withName: "obj_0", recursively: true)!
        return node
    }
}
