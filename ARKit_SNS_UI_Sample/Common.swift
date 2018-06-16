//
//  CardNodeList.swift
//  NSSOL_20180120_01
//
//  Created by 手塚竜太 on 2018/01/20.
//  Copyright © 2018年 手塚竜太. All rights reserved.
//

import Foundation

import UIKit
import SceneKit
import ARKit
let cardNum:Int = 30
var planeHeight:CGFloat = 0.001

extension SCNScene {
//    func createCardList() -> [SCNNode]{
//        var list: [SCNNode] = [SCNNode]()
//        for _ in 0..<cardNum {
//
//            let node = CardNode.init(comment: "comment1", userName: "taro.tanaka")
//            //            let node = CardNode.init(comment: "comment1")
//            list.append(node)
//            self.rootNode.addChildNode(node)
//        }
//        return list
//    }
//    
//    func removeSNSNode(SCNNodelist: [SCNNode]){
//        var list = SCNNodelist
//        var n:Int = 0
//        for node:SCNNode in list {
//            if (type(of: node) === SNSNode.self){
//                n = list.index(of: node)!
//                list.remove(at: n)
//            }
//        }
//    }
//    func getSNSNodeList(SCNNodelist: [SCNNode]) -> [SNSNode]{
//        let list = self.rootNode.childNodes
//        var SNSNodeList = [SNSNode]()
//        for node:SCNNode in list {
//            if (type(of: node) === SNSNode.self){
//                SNSNodeList.append(node as! SNSNode)
//            }
//        }
//        return SNSNodeList
//    }
//    
//    func addSNSNode(){
//        let node = SNSNode.init(service: "Twitter", cardNum: cardNum)
//        self.rootNode.addChildNode(node)
//    }
}


extension UIColor {
    class var arBlue: UIColor {
        get {
            return UIColor(red: 0.141, green: 0.540, blue: 0.816, alpha: 1)
        }
    }
}

extension ARSession {
    func run() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true
        run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
}

extension SCNNode {

     class func sphereNode(color: UIColor) -> SCNNode {
     let geometry = SCNSphere(radius: 0.01)
     geometry.materials.first?.diffuse.contents = color
     return SCNNode(geometry: geometry)
     }
     
     class func textNode(text: String) -> SCNNode {
     let geometry = SCNText(string: text, extrusionDepth: 0.01)
     geometry.alignmentMode = kCAAlignmentCenter
     if let material = geometry.firstMaterial {
     material.diffuse.contents = UIColor.white
     material.isDoubleSided = true
     }
     let textNode = SCNNode(geometry: geometry)
     
     geometry.font = UIFont.systemFont(ofSize: 1)
     textNode.scale = SCNVector3Make(0.02, 0.02, 0.02)
     
     // Translate so that the text node can be seen
     let (min, max) = geometry.boundingBox
     textNode.pivot = SCNMatrix4MakeTranslation((max.x - min.x)/2, min.y - 0.5, 0)
     
     // Always look at the camera
     let node = SCNNode()
     let billboardConstraint = SCNBillboardConstraint()
     billboardConstraint.freeAxes = SCNBillboardAxis.Y
     node.constraints = [billboardConstraint]
     
     node.addChildNode(textNode)
     
     return node
     }
     
     class func lineNode(length: CGFloat, color: UIColor) -> SCNNode {
     let geometry = SCNCapsule(capRadius: 0.004, height: length)
     geometry.materials.first?.diffuse.contents = color
     let line = SCNNode(geometry: geometry)
     
     let node = SCNNode()
     node.eulerAngles = SCNVector3Make(Float.pi/2, 0, 0)
     node.addChildNode(line)
     
     return node
     }
     
     func loadDuck() {
     guard let scene = SCNScene(named: "duck.scn", inDirectory: "models.scnassets/duck") else {fatalError()}
     for child in scene.rootNode.childNodes {
     child.geometry?.firstMaterial?.lightingModel = .physicallyBased
     addChildNode(child)
     }
     }
}

extension SCNView {
    
    private func enableEnvironmentMapWithIntensity(_ intensity: CGFloat) {
        if scene?.lightingEnvironment.contents == nil {
            if let environmentMap = UIImage(named: "models.scnassets/sharedImages/environment_blur.exr") {
                scene?.lightingEnvironment.contents = environmentMap
            }
        }
        scene?.lightingEnvironment.intensity = intensity
    }
    
    func updateLightingEnvironment(for frame: ARFrame) {
        // If light estimation is enabled, update the intensity of the model's lights and the environment map
        let intensity: CGFloat
        if let lightEstimate = frame.lightEstimate {
            intensity = lightEstimate.ambientIntensity / 400
        } else {
            intensity = 2
        }
        DispatchQueue.main.async(execute: {
            self.enableEnvironmentMapWithIntensity(intensity)
        })
    }
}


