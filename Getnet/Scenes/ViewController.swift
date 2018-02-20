//
//  ViewController.swift
//  Getnet
//
//  Created by Rodrigo Leite on 2/17/18.
//  Copyright © 2018 Rodrigo Leite. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController {

    // MARK: - IBOUTLET
    @IBOutlet weak var planeDectedLabel: UILabel! {
        didSet {
            planeDectedLabel.isHidden = true
        }
    }
    @IBOutlet weak var sceneView: ARSCNView!
    
    // MARK: - VARIABLES
    let configuration = ARWorldTrackingConfiguration()
    
    // MARK: - VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration.planeDetection = [.horizontal, .vertical]
        sceneView.session.run(configuration)
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - HANDLE ACTIONS
    @objc func handleTap(sender: UITapGestureRecognizer) {
        guard let sceneView = sender.view as? ARSCNView else {return}
        let touchLocation = sender.location(in: sceneView)
        let hitTestResult = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
        if !hitTestResult.isEmpty {
            // Add Portal
            addPortal(hitTestResult: hitTestResult.first!)
        }
    }
    
    // MARK: - LOGIC
    func restartSession() {
        sceneView.session.pause()
        sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func addPortal(hitTestResult: ARHitTestResult) {
        let portalScene = SCNScene(named: "Art.scnassets/Portal.scn")
        let portalNode = portalScene!.rootNode.childNode(withName: "Portal", recursively: false)!
        let transform = hitTestResult.worldTransform
        let planeXposition = transform.columns.3.x
        let planeYposition = transform.columns.3.y
        let planeZposition = transform.columns.3.z
        portalNode.position =  SCNVector3(planeXposition, planeYposition, planeZposition)
        sceneView.scene.rootNode.addChildNode(portalNode)
        setupMaskProperties(rootNode: portalNode)
//        addPlane(nodeName: "roof", portalNode: portalNode, imageName: "top")
//        addPlane(nodeName: "floor", portalNode: portalNode, imageName: "bottom")
//        addWalls(nodeName: "backWall", portalNode: portalNode, imageName: "back")
//        addWalls(nodeName: "sideWallA", portalNode: portalNode, imageName: "sideA")
//        addWalls(nodeName: "sideWallB", portalNode: portalNode, imageName: "sideB")
//        addWalls(nodeName: "sideDoorA", portalNode: portalNode, imageName: "sideDoorA")
//        addWalls(nodeName: "sideDoorB", portalNode: portalNode, imageName: "sideDoorB")
    }
    
    func setupMaskProperties(rootNode: SCNNode) {
        for node in rootNode.childNodes {
            if node.name != "mask" {
                node.renderingOrder = 200
            }
            if let child = node.childNode(withName: "mask", recursively: false) {
                child.geometry?.firstMaterial?.transparency = 0.000001

            }
        }
        let shopRootNode = rootNode.childNode(withName: "Shop reference", recursively: false)
        for node in (shopRootNode?.childNodes.first?.childNodes)! {
                node.renderingOrder = 200
        }
        
    }
    
//    func addWalls(nodeName: String, portalNode: SCNNode, imageName: String) {
//        let child = portalNode.childNode(withName: nodeName, recursively: true)
//        child?.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Art.scnassets/\(imageName).png")
//        child?.renderingOrder = 200
//        if let mask = child?.childNode(withName: "mask", recursively: false) {
//            mask.geometry?.firstMaterial?.transparency = 0.000001
//        }
//    }
//    
//    
//    func addPlane(nodeName: String, portalNode: SCNNode, imageName: String) {
//        let child = portalNode.childNode(withName: nodeName, recursively: true)
//        child?.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Art.scnassets/\(imageName).png")
//        child?.renderingOrder = 200
//    }
    
    
    // MARK: - IBACTION
    @IBAction func didTouchResetButton(_ sender: UIButton) {
        restartSession()
    }
    
}

extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else {return}
        DispatchQueue.main.async {
            self.planeDectedLabel.isHidden = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.planeDectedLabel.isHidden = true
        }
    }
    
}
