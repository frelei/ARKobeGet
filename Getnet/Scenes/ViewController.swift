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
            //self.addPortal(hitTestResult: hitTestResult.first!)
        }
    }
    
    func restartSession() {
        sceneView.session.pause()
        sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    
    // MARK: - IBACTION
    @IBAction func didTouchResetButton(_ sender: UIButton) {
        restartSession()
    }
    
}

extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else {return}
        DispatchQueue.main.async {
            self.planeDetected.isHidden = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.planeDetected.isHidden = true
        }
    }
    
}
