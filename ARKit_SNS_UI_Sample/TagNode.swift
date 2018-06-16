//
//  TagNode.swift
//  NSSOL_20180120_01
//
//  Created by 手塚竜太 on 2018/03/03.
//  Copyright © 2018年 手塚竜太. All rights reserved.
//

import SceneKit
import Vision

class TagNode: SCNNode {
    
    var classificationObservation: VNClassificationObservation? {
        
        // オブジェクトが変更後に呼び出される。TextNodeを追加(add)する
        
        didSet {
            addTextNode()
            
        }
    }
    
    private func addTextNode() {
        guard let text = classificationObservation?.identifier else {return}
        let shorten = text.components(separatedBy: ", ").first!
//        if shorten == "laptop" || shorten == "notebook" {
            let textNode = SCNNode.textNode(text: shorten)
            DispatchQueue.main.async(execute: {
                self.addChildNode(textNode)
//                let node = SNSNode.init(service: "Twitter", cardNum: cardNum)
//                self.addChildNode(node)
//                let line = SCNLine.init(from: node.position, to: textNode.position)
//                self.addChildNode(line)
            })
            addSphereNode(color: UIColor.green)
//        }
    }
    
    private func addSphereNode(color: UIColor) {
        DispatchQueue.main.async(execute: {
            let sphereNode = SCNNode.sphereNode(color: color)
            sphereNode.name = "sphereNode"
//            print("spName = ",sphereNode.name)
            self.addChildNode(sphereNode)
        })
    }
}
