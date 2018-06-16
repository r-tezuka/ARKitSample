//
//  ViewController.swift
//  NSSOL_20180120_01
//
//  Created by 手塚竜太 on 2018/01/20.
//  Copyright © 2018年 手塚竜太. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import CoreML
import Vision

class ViewController: UIViewController, ARSCNViewDelegate, UIGestureRecognizerDelegate, SCNPhysicsContactDelegate{
    
    private var model: VNCoreMLModel!
    private var screenCenter: CGPoint?
    
    private let serialQueue = DispatchQueue(label: "com.shu223.arkit.objectdetection")
    private var isPerformingCoreML = false
    private var isSNSNodeExist = false
    
    private var latestResult: VNClassificationObservation?
    private var tags: [TagNode] = []
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var trackingStateLabel: UILabel!

    var isOpen: Bool = false
    var nodeList:[SCNNode] = []
    var action = CardAction.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Core MLモデルの準備
        model = try! VNCoreMLModel(for: Inceptionv3().model)

        // Set the view's delegate
        sceneView.delegate = self
//        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // Show statistics such as fps and timing information
//        sceneView.showsStatistics = true

        // Set the scene to the view
        
        //タップジェスチャーの設定
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(ViewController.tapped(_:)))
        // デリゲートをセット
        tapGesture.delegate = self as UIGestureRecognizerDelegate
        self.view.addGestureRecognizer(tapGesture)
        
//        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("didSwipe:"))
//        rightSwipe.direction = .right
//        view.addGestureRecognizer(rightSwipe)
//
//        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("didSwipe:"))
//        leftSwipe.direction = .left
//        view.addGestureRecognizer(leftSwipe)
        
        //スワイプ（右）ジェスチャーの設定
        let rightSwipe:UISwipeGestureRecognizer = UISwipeGestureRecognizer(
            target: self,
            action: #selector(ViewController.didSwipe(sender:)))
        rightSwipe.direction = .right
        rightSwipe.delegate = self as UIGestureRecognizerDelegate
        self.view.addGestureRecognizer(rightSwipe)

        //スワイプ（左）ジェスチャーの設定
        let leftSwipe:UISwipeGestureRecognizer = UISwipeGestureRecognizer(
            target: self,
            action: #selector(ViewController.didSwipe(sender:)))
        leftSwipe.direction = .left
        leftSwipe.delegate = self as UIGestureRecognizerDelegate
        self.view.addGestureRecognizer(leftSwipe)
        //スワイプ（下）ジェスチャーの設定
        let downSwipe:UISwipeGestureRecognizer = UISwipeGestureRecognizer(
            target: self,
            action: #selector(ViewController.didSwipe(sender:)))
        downSwipe.direction = .down
        downSwipe.delegate = self as UIGestureRecognizerDelegate
        self.view.addGestureRecognizer(downSwipe)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        screenCenter = CGPoint(x: sceneView.bounds.midX, y: sceneView.bounds.midY)
    }
    
    // MARK: - Private
    
    // リクエスト（VNCoreMLRequest）の生成とハンドラ処理
    
    private func coreMLRequest() -> VNCoreMLRequest {
        let request = VNCoreMLRequest(model: model, completionHandler: { (request, error) in
            guard let best = request.results?.first as? VNClassificationObservation  else {
                self.isPerformingCoreML = false
                return
            }
            print("best: \(best.identifier)")  //VNClassificationObservation.identifierが値のセット値
            
            // 信頼度が低い結果は採用しない
            if best.confidence < 0.5 {
                self.isPerformingCoreML = false
                return
            }
            
            // 初めて出る認識結果か？（連続してタグ付けされることを防ぐため）
            if self.isFirstOrBestResult(result: best) {
                self.latestResult = best
                self.recognitionTest()
            }
            
            self.isPerformingCoreML = false
        })
        request.preferBackgroundProcessing = true
        
        // 画面の中心でクロップした画像を利用する
        request.imageCropAndScaleOption = .centerCrop
        
        return request
    }
    
    private func performCoreML() {
        
        serialQueue.async {
            guard !self.isPerformingCoreML else {return}
            guard !self.isSNSNodeExist else {return}
            // CVPixelBufferのセット
            
            // CVPixelBufferは、メインメモリ内のピクセルを保持するイメージバッファであり、フレームを生成するアプリや、Core Imageを使用するアプリで利用される。
            // CoreMLの入力には、CVPixelBufferが必要。
            // UIImage等は、変換する必要がある。また入力画像は、モデルごとサイズが決まっており、ここも合わせる必要がある。
            
            guard let imageBuffer = self.sceneView.session.currentFrame?.capturedImage else {return}
            self.isPerformingCoreML = true
            
            // ハンドラの生成と実行
            
            let handler = VNImageRequestHandler(cvPixelBuffer: imageBuffer)
            let request = self.coreMLRequest()
            do {
                try handler.perform([request])
            } catch {
                print(error)
                self.isPerformingCoreML = false
            }
        }
    }
    
    // 初めて出る結果か、前回より良い結果か
    private func isFirstOrBestResult(result: VNClassificationObservation) -> Bool {
        for tag in tags {
            guard let prevRes = tag.classificationObservation else {continue}
            if prevRes.identifier == result.identifier {
                // 前回より良い場合は、前回のを削除
                if prevRes.confidence < result.confidence {
                    if let index = tags.index(of: tag) {
                        tags.remove(at: index)
                    }
                    tag.removeFromParentNode()
                    return true
                }
                // 重複するノードが既にあり、前回分の方が信頼度が高い
                return false
            }
        }
        return true
    }
    
    private func recognitionTest() {
        guard let frame = sceneView.session.currentFrame else {return}
        let state = frame.camera.trackingState
        switch state {
        case .normal:
            guard let pos = screenCenter else {return}
            DispatchQueue.main.async(execute: {
                self.recognitionTest(pos)
            })
        default:
            break
        }
    }
    
    private func recognitionTest(_ pos: CGPoint) {
        // 平面を対象にヒットテストを実行
        let results1 = sceneView.hitTest(pos, types: [.existingPlaneUsingExtent, .estimatedHorizontalPlane])
        if let result = results1.first {
            addTag(for: result)
            return
        }
        
        // 特徴点を対象にヒットテストを実行
        let results2 = sceneView.hitTest(pos, types: .featurePoint)
        if let result = results2.first {
            addTag(for: result)
        }
    }
    
    private func addTag(for hitTestResult: ARHitTestResult) {
        let tagNode = TagNode()
        tagNode.transform = SCNMatrix4(hitTestResult.worldTransform)
        tags.append(tagNode)
        tagNode.classificationObservation = latestResult
        sceneView.scene.rootNode.addChildNode(tagNode)
    }
    
    //画面をタップした際の処理
    @IBAction func tapped(_ sender: UITapGestureRecognizer) {
        let tapPoint = sender.location(in: sceneView)
        let results = sceneView.hitTest(tapPoint)
        if results.count > 0 {
            let hitNode = results.first?.node
            if (hitNode?.name == Optional("SNSNode")) {
                let snsNode = hitNode as! SNSNode
                print((snsNode.name!) + "がタップされました")
//                let transform = snsNode.worldTransform
                nodeList = snsNode.createCardList()
                action.tornado(nodeList: nodeList)
//                action.tornado(nodeList: nodeList, basePosition: transform)
                
            }
            if (hitNode?.name == Optional("sphereNode")) {
                let sphereNode = hitNode
                let transform = sphereNode?.worldTransform
                let tnode = SNSNode.init(service: "Twitter", cardNum: cardNum)
                tnode.worldPosition.x = (transform?.m41)! - 0.02
                tnode.worldPosition.y = (transform?.m42)! + 0.2
                tnode.worldPosition.z = (transform?.m43)!
                sceneView.scene.rootNode.addChildNode(tnode)
//                let line = SCNLine.init(from: node.worldPosition, to: (sphereNode?.worldPosition)!)
                let tline = SCNLine.init(from: SCNVector3(0,0,0), to: SCNVector3(0.02,-0.2,0))
                tnode.addChildNode(tline)
                
                let fnode = SNSNode.init(service: "Facebook", cardNum: cardNum)
                fnode.worldPosition.x = (transform?.m41)! + 0.02
                fnode.worldPosition.y = (transform?.m42)! + 0.2
                fnode.worldPosition.z = (transform?.m43)!
                sceneView.scene.rootNode.addChildNode(fnode)
                let fline = SCNLine.init(from: SCNVector3(0,0,0), to: SCNVector3(-0.02,-0.2,0))
                fnode.addChildNode(fline)
                isSNSNodeExist = true
            }
            
//            let hitNode = results.first?.node
//            guard let snsNode:SNSNode = hitNode as? SNSNode else{return}
//            print(snsNode.name! + "がタップされました")
//
//            if(isOpen){
//                //sceneView.scene.removeCardNode()
//                isOpen = false
//            }else{
//                let transform = snsNode.worldTransform
//                nodeList = snsNode.createCardList()
//                action.tornadoInit(nodeList: nodeList, basePosition: transform)
//                isOpen = true
//            }
        }
    }
    
    //画面をスワイプした際の処理
    @IBAction func didSwipe(sender: UISwipeGestureRecognizer) {
        
        if sender.direction == .right {
            print("Right")
            action.tornado(nodeList: nodeList)
        }
        else if sender.direction == .left {
            print("Left")
            action.square(nodeList: nodeList)
        }
        else if sender.direction == .down {
            print("Down")
            action.flooing(nodeList: nodeList)
            SCNAction.wait(duration: TimeInterval(3))
            action.drop(nodeList: nodeList)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true

//         Run the view's session
        sceneView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

//         Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
//         Release any cached data, images, etc that aren't in use.
    }

//     MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    // rendererで更新された場合にに物体認識を実行する
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let frame = sceneView.session.currentFrame else {return}
        sceneView.updateLightingEnvironment(for: frame)
        // Core MLによる物体認識を実行
        performCoreML()
    }
    
    //planeを追加する際のレンダリング
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {fatalError()}
        planeAnchor.addPlaneNode(on: node, color: UIColor.arBlue.withAlphaComponent(0.2))
    }
    //planeを更新する際のレンダリング
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {fatalError()}
        planeAnchor.updatePlaneNode(on: node)
    }
    //planeを除外する際のレンダリング
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        print("\(self.classForCoder)/" + #function)
    }
}
