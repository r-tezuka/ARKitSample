//
//  CardNode.swift
//  NSSOL_20180120_01
//
//  Created by 手塚竜太 on 2018/01/20.
//  Copyright © 2018年 手塚竜太. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import ARKit

class CardNode: SCNNode {
    var comment:String = ""
    var userName:String = "unknown"
    var icon:String = "art.scnassets/社長のアイコン64.png"
    
    init(comment: String, userName: String, icon: String){
        super.init()
        self.comment = comment
        self.userName = userName
        self.icon = icon

        //カード状(直方体)の3Dモデルの作成
        self.geometry = SCNBox(width: 0.05, height: 0.05, length: 0.001, chamferRadius: 0)
        //Nodeの初期位置の指定
        self.position = SCNVector3(0, 0.5, 0)
        
        // SCNBoxの表面に貼り付けるマテリアルを作成
        let textContent = SCNMaterial()
        let textBoxFrame = SCNMaterial()

        textContent.diffuse.contents = commentSurface(node: self)
        textBoxFrame.diffuse.contents = UIColor.init(white: 0.7, alpha: 0.2)

        //作成したマテリアルを直方体の各面に適用
        self.geometry?.materials = [textContent, textBoxFrame, textBoxFrame, textBoxFrame, textBoxFrame, textBoxFrame]
        
    }
    
    init(comment: String, userName: String){
        super.init()
        self.comment = comment
        self.userName = userName
        
        //カード状(直方体)の3Dモデルの作成
        self.geometry = SCNBox(width: 0.05, height: 0.05, length: 0.001, chamferRadius: 0.2)
        //Nodeの初期位置の指定
        self.position = SCNVector3(0, 0.5, 0)
        
        // SCNBoxの表面に貼り付けるマテリアルを作成
        let textContent = SCNMaterial()
        let textBoxFrame = SCNMaterial()
        
        textContent.diffuse.contents = commentSurface(node: self)
        textBoxFrame.diffuse.contents = UIColor.init(white: 0.7, alpha: 0.2)
        
        //作成したマテリアルを直方体の各面に適用
        self.geometry?.materials = [textContent, textBoxFrame, textBoxFrame, textBoxFrame, textBoxFrame, textBoxFrame]
        
    }
    init(comment: String){
        super.init()
        self.comment = comment
        
        //カード状(直方体)の3Dモデルの作成
        self.geometry = SCNBox(width: 0.1, height: 0.025, length: 0.001, chamferRadius: 0)
//        let textBoxFrame = SCNMaterial()
//        textBoxFrame.diffuse.contents = UIColor.init(white: 0.7, alpha: 0.2)
//        //作成したマテリアルを直方体の各面に適用
//        self.geometry?.materials = [textBoxFrame, textBoxFrame, textBoxFrame, textBoxFrame, textBoxFrame, textBoxFrame]
        
        //Nodeの初期位置の指定
        self.position = SCNVector3(0, 0.5, 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

