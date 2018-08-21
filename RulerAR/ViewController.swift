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
  @IBOutlet weak var distanceAlabel: UILabel!
  @IBOutlet weak var distanceBlabel: UILabel!
  
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
    let mid = dotNodes[1]
    if dotNodes.count > 2 {
      let end = dotNodes[2]
      distanceB = mid.position.distance(from: end.position)
    }
    
    distanceA = start.position.distance(from: mid.position)

    
    updateText(textA: distanceA, textB: distanceB)
  }
  
  //MARK: - Adding a text overlay
  func updateText(textA: Float, textB: Float) {
    
    let valueCMA = textA * 100
    let valueCMB = textB * 100
    
    distanceAlabel.text = String(format: "%.2fcm", valueCMA)
    distanceBlabel.text = String(format: "%.2fcm", valueCMB)

  }
  
  //    textNode.removeFromParentNode()
  //
  //    let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
  //
  //    textGeometry.firstMaterial?.diffuse.contents = UIColor.red
  //
  //    textNode = SCNNode(geometry: textGeometry)
  //
  //    textNode.position = atPosition
  //    textNode.scale = SCNVector3(0.01, 0.01, 0.01)
  
  //    sceneView.scene.rootNode.addChildNode(textNode)
  
  //MARK: - Button action
  @IBAction func addMarker(_ sender: Any) {
    
    // removing dots if more than 3
    if dotNodes.count >= 3 {
      for dot in dotNodes {
        dot.removeFromParentNode()
        updateText(textA: 0.0, textB: 0.0)
      }
      dotNodes = [SCNNode]()
    }
    
    // converting CGpoint to SCNVector3
    if let vector = sceneView.realWorldVector(screenPos: sceneView.center){
    addDot(at: vector)
    }
    
  }
  
  
}


















