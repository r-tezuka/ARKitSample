//
//  SNSNode.swift
//  NSSOL_20180120_01
//
//  Created by 手塚竜太 on 2018/01/21.
//  Copyright © 2018年 手塚竜太. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import ARKit

class SNSNode: SCNNode {
    var color = UIColor.white
    var cardNum:Int = 0
    var iconFileName = ""
    var rad = CGFloat(0.02)
    var initPosition = SCNVector3(0, 0.05, 0)
    let dataMatrix:[[String]] = [
                                ["comment1", "taro.tanaka", "art.scnassets/社長のアイコン64.png"],
                                ["comment2","taro.tanaka", "art.scnassets/社長のアイコン64.png"],
                                ["comment3", "taro.tanaka", "art.scnassets/社長のアイコン64.png"],
                                ["comment4", "taro.tanaka", "art.scnassets/社長のアイコン64.png"],
                                ["comment5", "taro.tanaka", "art.scnassets/社長のアイコン64.png"],
                                ["comment6", "taro.tanaka", "art.scnassets/社長のアイコン64.png"],
                                ["comment7", "taro.tanaka", "art.scnassets/社長のアイコン64.png"],
                                ["comment8", "taro.tanaka", "art.scnassets/社長のアイコン64.png"],
                                ["comment9", "taro.tanaka", "art.scnassets/社長のアイコン64.png"],
                                ["comment10", "taro.tanaka", "art.scnassets/社長のアイコン64.png"],
                                ["comment11", "taro.tanaka", "art.scnassets/社長のアイコン64.png"],
                                ["comment12", "taro.tanaka", "art.scnassets/社長のアイコン64.png"],
                                ["comment13", "taro.tanaka", "art.scnassets/社長のアイコン64.png"],
                                ["comment14", "taro.tanaka", "art.scnassets/社長のアイコン64.png"],
                                ["comment15", "taro.tanaka", "art.scnassets/社長のアイコン64.png"],
                                ["comment16", "taro.tanaka", "art.scnassets/社長のアイコン64.png"],
                                ["comment17", "taro.tanaka", "art.scnassets/社長のアイコン64.png"],
                                ["comment18", "taro.tanaka", "art.scnassets/社長のアイコン64.png"],
                                ["comment19", "taro.tanaka", "art.scnassets/社長のアイコン64.png"],
                                ["comment20", "taro.tanaka", "art.scnassets/社長のアイコン64.png"],
                                ["comment21", "taro.tanaka", "art.scnassets/社長のアイコン64.png"],
                                ["comment22", "taro.tanaka", "art.scnassets/社長のアイコン64.png"],
                                ["comment23", "taro.tanaka", "art.scnassets/社長のアイコン64.png"],
                                ["comment24", "taro.tanaka", "art.scnassets/社長のアイコン64.png"],
                                ["comment25", "taro.tanaka", "art.scnassets/社長のアイコン64.png"],
                                ["comment26", "taro.tanaka", "art.scnassets/社長のアイコン64.png"],
                                ["comment27", "taro.tanaka", "art.scnassets/社長のアイコン64.png"],
                                ["comment28", "taro.tanaka", "art.scnassets/社長のアイコン64.png"],
                                ["comment29", "taro.tanaka", "art.scnassets/社長のアイコン64.png"],
                                ["comment30", "taro.tanaka", "art.scnassets/社長のアイコン64.png"]]
    
    init(service: String, cardNum: Int){
        super.init()
        self.name = service
        self.cardNum = cardNum
        if(service == "Twitter"){
            //colorは 8bit colorで 255 = 1 という換算
            self.color = UIColor.init(red: 0.333, green: 0.675, blue: 0.933, alpha: 0.4)
            self.iconFileName = "art.scnassets/twitter128.png"
            self.createBlock()
        }
        if(service == "Facebook"){
            self.color = UIColor.init(red: 0.09, green: 0.137, blue: 0.234, alpha: 0.4)
            self.iconFileName = "art.scnassets/FACEBOOK128.png"
            self.createBlock()

//            作成中
        }
        
    }
    
//    func createPlate() {
//        // 円形プレートの作成
//        self.geometry = SCNCylinder(radius: rad, height: 0.001)
//        let frame = SCNMaterial()
//        let iconContent = SCNMaterial()
//        let numContent = SCNMaterial()
//        iconContent.diffuse.contents = SNSIconSurface(node: self)
//        numContent.diffuse.contents = SNSCardNumSurface(node: self)
//        frame.diffuse.contents = self.color
//
//        //作成したマテリアルを円形プレートの各面に適用
//        self.geometry?.materials = [frame, iconContent, numContent]
//
//        //Nodeの初期位置の指定
//        self.position = initPosition
//        self.rotation = SCNVector4(1, 0, 0, 0.5 * Float.pi)
////        self.rotation = SCNVector4(1, 0, 0, 0.5 * Float.pi)
//
//    }
    func createBlock() {
        self.name = "SNSNode"
        // 矩型プレートの作成
        self.geometry = SCNBox(width: 0.03, height: 0.03, length: 0.03, chamferRadius: 0.003)
//        let frame = SCNMaterial()
        let iconContent = SCNMaterial()
        let numContent = SCNMaterial()
        iconContent.diffuse.contents = SNSIconSurface(node: self)
        numContent.diffuse.contents = SNSCardNumSurface(node: self)
//        frame.diffuse.contents = self.color
        
        //作成したマテリアルを円形プレートの各面に適用
        self.geometry?.materials = [iconContent, iconContent, iconContent, iconContent, numContent, iconContent]
        //Nodeの初期位置の指定
        self.position = initPosition
    }
    
    func createCardList() -> [SCNNode]{
        var list: [SCNNode] = [SCNNode]()
        for i in 0..<cardNum {
            
            let node = CardNode.init(comment: dataMatrix[i][0], userName: dataMatrix[i][1], icon: dataMatrix[i][2])
            //            let node = CardNode.init(comment: "comment1")
            list.append(node)
            self.addChildNode(node)
        }
        return list
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
