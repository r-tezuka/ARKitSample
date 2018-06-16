//
//  SCNLine.swift
//  NSSOL_20180120_01
//
//  Created by 手塚竜太 on 2018/03/04.
//  Copyright © 2018年 手塚竜太. All rights reserved.
//

import UIKit
import SceneKit

class SCNLine: SCNNode{
    init(from : SCNVector3, to : SCNVector3){
        super.init()
        self.update(from: from, to: to)
    }
//    init(from : SCNVector3, to : SCNVector3){
//        super.init()
//        let source = SCNGeometrySource.init(vertices: [from, to])
//        let indices : [UInt8] = [0, 1]
//        let data = Data.init(bytes: indices)
//        let element = SCNGeometryElement.init(data: data, primitiveType: .line, primitiveCount: 1, bytesPerIndex: 1)
//        let geometry = SCNGeometry.init(sources: [source], elements: [element])
//        self.geometry = geometry
//        let material = SCNMaterial.init()
//        material.diffuse.contents = UIColor.init(white: 1, alpha: 1)
//        self.geometry!.insertMaterial(material, at: 0)
//    }
    
//    func update(node : SCNLine, from : SCNVector3, to : SCNVector3) -> SCNLine{
//        let source = SCNGeometrySource.init(vertices: [from, to])
////        node.geometry?.sources.removeAll()
////        node.geometry?.sources.append(source)
//        return node
//    }
    func update(from : SCNVector3, to : SCNVector3){
        let source = SCNGeometrySource.init(vertices: [from, to])
        let indices : [UInt8] = [0, 1]
        let data = Data.init(bytes: indices)
        let element = SCNGeometryElement.init(data: data, primitiveType: .line, primitiveCount: 1, bytesPerIndex: 1)
        let geometry = SCNGeometry.init(sources: [source], elements: [element])
        self.geometry = geometry
        let material = SCNMaterial.init()
        material.diffuse.contents = UIColor.init(white: 1, alpha: 1)
        self.geometry!.insertMaterial(material, at: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
