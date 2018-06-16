//
//  SCNSurface.swift
//  NSSOL_20180120_01
//
//  Created by 手塚竜太 on 2018/01/21.
//  Copyright © 2018年 手塚竜太. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import ARKit

extension SCNNode{
    func commentSurface (node: CardNode) -> SKScene {
        
        // SKSceneを生成する
        let skScene = SKScene(size: CGSize(width: 512, height: 512))
        skScene.backgroundColor = UIColor.init(white: 0, alpha: 0)
        
        //アイコン背景
        let iconBack = SKShapeNode()
        iconBack.fillColor = UIColor.init(white: 1, alpha: 1)
        iconBack.position = CGPoint(x: skScene.size.width / 2.0, y: skScene.size.height / 8.0)
        skScene.addChild(iconBack)
        
//        アイコン
                let icon = SKSpriteNode(imageNamed: node.icon)
                icon.position = CGPoint(x: skScene.size.width / 4.0, y: skScene.size.height / 2.0)
                icon.yScale = -1.0
                skScene.addChild(icon)
        
//        //外枠
//        let balloon = SKShapeNode(rect: CGRect.init(x: skScene.position.x, y: skScene.position.y, width: 512, height: 128), cornerRadius: 20)
//        balloon.fillColor = UIColor.init(white: 0.7, alpha: 0.2)
//        skScene.addChild(balloon)
        
        //ユーザー名
        let userLabel = SKLabelNode(text: node.userName)
        userLabel.fontName = "HiraginoSans-W8"
        userLabel.fontColor = UIColor.black
        
        // ユーザー名の配置
        userLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        userLabel.position = CGPoint(x: (skScene.size.width / 2.0), y: skScene.size.height / 6.0)
        
        // 座標系を上下逆にする
        userLabel.yScale = -1.0
        //Nodeとして追加
        skScene.addChild(userLabel)
        
        //Commentの書式設定
        let commentLabel = SKLabelNode(text: node.comment)
        commentLabel.fontName = "HiraginoSans-W8"
        commentLabel.fontColor = UIColor.black
        // Commentの配置
        commentLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        commentLabel.position = CGPoint(x: userLabel.position.x, y: userLabel.position.y + 50)
        
        //        commentLabel.position = CGPoint(x: skScene.size.width / 2.0, y: skScene.size.height / 2.0)
        
        // 座標系を上下逆にする
        commentLabel.yScale = -1.0
        //Nodeとして追加
        skScene.addChild(commentLabel)
        
        return skScene
        
    }
    
    func SNSIconSurface (node: SNSNode) -> SKScene {
        // SKSceneを生成する
        let skScene = SKScene(size: CGSize(width: 256, height: 256))
        skScene.backgroundColor = node.color
        
        //アイコン背景
//        let iconBack = SKShapeNode(circleOfRadius: 50)
//        iconBack.fillColor = UIColor.init(white: 1, alpha: 1)
//        iconBack.position = CGPoint(x: skScene.size.width / 2.0, y: skScene.size.height / 2.0)
//        skScene.addChild(iconBack)
        
        //アイコン
        let icon = SKSpriteNode(imageNamed: node.iconFileName)
        icon.position = CGPoint(x: skScene.size.width / 2.0, y: skScene.size.height / 2.0)
        icon.yScale = -1.0
        skScene.addChild(icon)
        
        return skScene
        
    }
    
    func SNSCardNumSurface (node: SNSNode) -> SKScene {
        // SKSceneを生成する
        let skScene = SKScene(size: CGSize(width: 256, height: 256))
        skScene.backgroundColor = node.color
        
        let numLabel = SKLabelNode(text: String(node.cardNum))
        numLabel.fontName = "HiraginoSans-W8"
        numLabel.fontColor = UIColor.black
        numLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        numLabel.position = CGPoint(x: skScene.size.width / 2.0, y: skScene.size.height / 2.0)
        
        skScene.addChild(numLabel)
        return skScene
    }
}
