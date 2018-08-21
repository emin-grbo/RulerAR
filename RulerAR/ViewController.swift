//
//  ViewController.swift
//  RulerAR
//
//  Created by Emin Roblack on 8/15/18.
//  Copyright © 2018 emiN Roblack. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
  
  var dotNodes = [SCNNode]()
  var textNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()

      // Set the view's delegate
      sceneView.delegate = self
      sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
  
  //MARK: - Touch Detection
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    if dotNodes.count >= 2 {
      for dot in dotNodes {
        dot.removeFromParentNode()
      }
      dotNodes = [SCNNode]()
    }

    if let touchLocation = touches.first?.location(in: sceneView) {
      let hitTestResults = sceneView.hitTest(touchLocation, types: .featurePoint)
      
      if let hitResult = hitTestResults.first {
        addDot(at: hitResult)
      }
      
    }
  }
  
  //MARK: - Adding a dot
  func addDot(at hitResult: ARHitTestResult) {
    
    let dot = SCNSphere(radius: 0.005)
    
    let dotMaterial = SCNMaterial()
    dotMaterial.diffuse.contents = UIColor.red
    
    dot.materials = [dotMaterial]
    
    
    let dotNode = SCNNode(geometry: dot)
    
    dotNode.position = SCNVector3(
      hitResult.worldTransform.columns.3.x,
      hitResult.worldTransform.columns.3.y,
      hitResult.worldTransform.columns.3.z
    )

      sceneView.scene.rootNode.addChildNode(dotNode)
    
    dotNodes.append(dotNode)
    
    if dotNodes.count >= 2 {
      calculate()
    }
  }
  
  //MARK: - Calculate distance
  func  calculate() {
    let start = dotNodes[0]
    let end = dotNodes[1]
    
    print(start.position)
    print(end.position)
    
    let a = end.position.x - start.position.x
    let b = end.position.y - start.position.y
    let c = end.position.z - start.position.z
    
    let distance = sqrt(pow(a,2) + pow(b,2) + pow(c,2))
    
    updateText(text: String(distance), atPosition: end.position)
  }
  
  
  //MARK: - Adding a text overlay
  func updateText(text: String, atPosition: SCNVector3) {
    
    textNode.removeFromParentNode()
    
    let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
    
    textGeometry.firstMaterial?.diffuse.contents = UIColor.red
    
    textNode = SCNNode(geometry: textGeometry)
    
    textNode.position = atPosition
    textNode.scale = SCNVector3(0.01, 0.01, 0.01)
    
    sceneView.scene.rootNode.addChildNode(textNode)
    
  }
  
  @IBAction func addMarker(_ sender: Any) {
    
    let vector = sceneView.realWorldVector(screenPos: sceneView.center)
    
    addDot(at: vector)
    
  }
  
  
}


















