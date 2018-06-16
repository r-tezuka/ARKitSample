//
//  CardActions.swift
//  NSSOL_20180120_01
//
//  Created by 手塚竜太 on 2018/01/20.
//  Copyright © 2018年 手塚竜太. All rights reserved.SZC
//

import Foundation
import UIKit
import SceneKit
import ARKit

class CardAction: SCNAction {
//    func tornadoInit (nodeList: [SCNNode], basePosition: SCNMatrix4) {
//
//        var nodeNum: Float = 0
//        var nodeLevel: Float = 0
//        var nodeWait: CGFloat = 0
//        for node in nodeList {
//            node.pivot = SCNMatrix4MakeTranslation(basePosition.m41, basePosition.m42, basePosition.m43)
//            node.removeAllActions()
//            node.runAction(
//                SCNAction.sequence([
//                    SCNAction.wait(duration: TimeInterval(nodeWait)),
//                    SCNAction.move(to: SCNVector3(0, 0.1 + 0.1*nodeLevel, 0), duration: 0.01),
//                    SCNAction.rotateBy(x: 0, y: CGFloat(6-nodeNum), z: 0, duration: 0.1),
//                    SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 0.5, z: 0, duration: 1))
//                    ])
//            )
//            nodeWait += 0.2
//            nodeNum += 1
//            if nodeNum == 5{
//                nodeLevel += 1
//                nodeNum = 0
//            }
//        }
//    }
    
    func tornado (nodeList: [SCNNode]) {
        var nodeNum: Float = 0
        var nodeLevel: Float = 0
        var nodeWait: CGFloat = 0
        for node in nodeList {
            node.pivot = SCNMatrix4MakeTranslation(0, 0, -0.04)
            let rotateY = CGFloat((2*Float.pi*(5-nodeNum)/5))
            node.removeAllActions()
            node.runAction(
                SCNAction.sequence([
                    SCNAction.wait(duration: TimeInterval(nodeWait)),
                    SCNAction.move(to: SCNVector3(0, 0.1 + 0.05*nodeLevel, 0), duration: 0.001),
                    SCNAction.rotateBy(x: 0, y: rotateY, z: 0, duration: 0.02),
                    SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 0.3, z: 0, duration: 1)),
                    ])
            )
            nodeWait += 0.01
            nodeNum += 1
            if nodeNum == 5{
                nodeLevel += 1
                nodeNum = 0
            }
        }
    }
    
    func square (nodeList: [SCNNode]) {
        var nodeNum: Float = 0
        var nodeLevel: Float = 0
        var nodeWait: CGFloat = 0
        for node in nodeList {
            node.removeAllActions()
            node.runAction(
                SCNAction.sequence([
                    SCNAction.wait(duration: TimeInterval(nodeWait)),
                    SCNAction.rotateTo(x: 0, y: 0, z: 0, duration: 0.01),
                    SCNAction.move(to: SCNVector3(0.01 + 0.05*nodeNum, 0.01 + 0.05*nodeLevel, 0.1), duration:0.01),
                    ])
            )
            nodeWait += 0.01
            nodeNum += 1
            if nodeNum == 5{
                nodeLevel += 1
                nodeNum = 0
            }
        }
    }
    
    func flooing (nodeList: [SCNNode]) {
        var nodeNum: Float = 0
        var nodeLevel: Float = 0
        var nodeWait: CGFloat = 0
        for node in nodeList {
            node.removeAllActions()
            node.runAction(
                SCNAction.sequence([
                    SCNAction.wait(duration: TimeInterval(nodeWait)),
                    SCNAction.rotateTo(x: -CGFloat.pi/2, y: 0, z: 0, duration: 0.01),
                    SCNAction.move(to: SCNVector3(0.01 + 0.05*nodeNum, -0.2, 0.01 + 0.05*nodeLevel), duration:0.01),
                    ])
            )
            nodeWait += 0.01
            nodeNum += 1
            if nodeNum == 5{
                nodeLevel += 1
                nodeNum = 0
            }
        }
    }
    
    func drop (nodeList: [SCNNode]) {
        for node in nodeList {
            guard let box: SCNBox = node.geometry as? SCNBox else{return}
            if box.height != planeHeight {
                // sceneView上でタップしたNodeを落下
                let hitNodeShape = SCNPhysicsShape(node: node, options: [SCNPhysicsShape.Option.type : SCNPhysicsShape.ShapeType.boundingBox])
                node.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.dynamic, shape: hitNodeShape)
            }
        }
    }
}
