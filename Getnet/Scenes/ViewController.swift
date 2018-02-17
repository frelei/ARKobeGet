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
    @IBOutlet weak var PlaneDectedLabel: UILabel!
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
        
    }
    
    
    @IBAction func didTouchResetButton(_ sender: UIButton) {
        
    }
    

}

extension ViewController: ARSCNViewDelegate {
    
    
    
}
