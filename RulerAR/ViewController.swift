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
  var distanceA: Float = 0.0
  var distanceB: Float = 0.0
    
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

    if let touchLocation = touches.first?.location(in: sceneView) {
      let hitTestResults = sceneView.hitTest(touchLocation, types: .featurePoint)
      
//      if let hitResult = hitTestResults.first {
//        //addDot(at: hitResult)
//      }
      
    }
  }
  
  //MARK: - Adding a dot
  func addDot(at centreVector: SCNVector3) {
    
    let dot = SCNSphere(radius: 0.005)
    
    let dotMaterial = SCNMaterial()
    dotMaterial.diffuse.contents = UIColor.red
    
    dot.materials = [dotMaterial]
    
    
    let dotNode = SCNNode(geometry: dot)
    
    dotNode.position = centreVector

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
    
    distanceA = start.position.distance(from: end.position)
    updateText(textA: distanceA, textB: distanceB)
//    distanceAlabel.frame.origin = CGPoint(x: 10.0, y: 10.0)
  }
  
  //MARK: - Adding a text overlay
  func updateText(textA: Float, textB: Float) {
    
    let distanceCM = String(format: "%.2f", (textA * 100))
    
    //MARK: 3D Text
    textNode.removeFromParentNode()
    
    let textGeometry = SCNText(string: distanceCM, extrusionDepth: 0.1)
    
    textGeometry.firstMaterial?.diffuse.contents = UIColor.red
    
    textNode = SCNNode(geometry: textGeometry)
    
    textNode.scale = SCNVector3(0.001, 0.001, 0.001)
    
    //MARK: TextNode Position
    let node1 = dotNodes[0].position
    let node2 = dotNodes[1].position

//    let dx = (node2.x + node1.x)/2.0
//    let dy = (node2.y + node1.y)/2.0
//    let dz = (node2.z + node1.z)/2.0
//    let position =  SCNVector3(dx, dy, dz)
//
//    textNode.position = position
    
    textNode.position = SCNVector3((node2.x + node1.x)/2.0,
                                   (node2.y + node1.y)/2.0,
                                   (node2.z + node1.z)/2.0)
    
//    textNode.eulerAngles = SCNVector3Make(0, .pi, 0)
    
//    let cameraNode = SCNNode()
//    cameraNode.camera = SCNCamera()
//    cameraNode.position = SCNVector3Make(0, 0, 10)
//    sceneView.scene.rootNode.addChildNode(cameraNode)
    
//    let wrapperNode = SCNNode()
//    wrapperNode.addChildNode(textNode)
    
//    let constraint = SCNLookAtConstraint(target: cameraNode)
//    constraint.isGimbalLockEnabled = true
//    wrapperNode.constraints = [constraint]
    
    //textNode.constraints = [SCNBillboardConstraint]()
    
    textNode.pivot = SCNMatrix4Rotate(textNode.pivot, Float.pi, 0, 1, 0)
    let lookAt = SCNLookAtConstraint(target: sceneView.pointOfView)
    lookAt.isGimbalLockEnabled = true
    textNode.constraints = [lookAt]
    
    sceneView.scene.rootNode.addChildNode(textNode)
    
  }
  

  
  //MARK: - Button action
  @IBAction func addMarker(_ sender: Any) {
    
    // removing dots if more than 3
    if dotNodes.count >= 2 {
      for dot in dotNodes {
        dot.removeFromParentNode()
      }
      dotNodes = [SCNNode]()
    }
    
    // converting CGpoint to SCNVector3
    if let vector = sceneView.realWorldVector(screenPos: sceneView.center){
    addDot(at: vector)
    }
    
  }
  
  
}


















